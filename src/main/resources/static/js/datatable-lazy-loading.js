(function ($) {
    let _lazy_loading_datatable;
    let _lazy_loading_datatable_data = [];
    let _lazy_loading_datatable_pages = 5;
    let _lazy_loading_datatable_page_size = 10;
    let _lazy_loading_datatable_size_ratio = 5;
    let _lazy_loading_datatable_page_number = 1;
    let _lazy_loading_datatable_total_size = 200;
    let _lazy_loading_datatable_ajax_request_url = "";
    let _lazy_loading_datatable_ajax_request_query_params = "";
    let _lazy_loading_datatable_ajax_request_search_query = "";

    $.fn.lazyLoadingDatatable = function (url, options, queryParams) {
        _lazy_loading_datatable_page_size = parseInt(sessionStorage.getItem("length.dt") == null ? 10 : sessionStorage.getItem("length.dt"));

        options.serverSide = false;
        options.processing = true;
        options.paging = true;
        options.iDisplayLength = _lazy_loading_datatable_page_size;

        _lazy_loading_datatable_ajax_request_query_params = queryParams;
        _lazy_loading_datatable_ajax_request_url = url;

        $.fn.dataTable.models.oSettings.fnRecordsTotal = function () {
            return _lazy_loading_datatable_total_size;
        };

        _lazy_loading_datatable = this.DataTable(options);
        _lazy_loading_datatable_initialize_listeners(this);
        _lazy_loading_datatable_size_ratio_by_size(_lazy_loading_datatable_page_size);
        _lazy_loading_datatable_pages = (_lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio) / _lazy_loading_datatable.page.info().length;
        _lazy_loading_datatable_ajax_request(_lazy_loading_datatable_ajax_request_url, 0, _lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio);

        return this;
    };

    $.fn.getDataTable = function () {
        return _lazy_loading_datatable;
    };

    $.fn.changeQueryParams = function (queryParams) {
        _lazy_loading_datatable_ajax_request_query_params = queryParams;
        return this;
    };

    $.fn.refresh = function () {
        _lazy_loading_datatable_ajax_request(_lazy_loading_datatable_ajax_request_url, 1, _lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio);
    };

    function _lazy_loading_datatable_size_ratio_by_size(size) {
        if (size >= 50) {
            _lazy_loading_datatable_size_ratio = 2;
        } else if (size >= 25) {
            _lazy_loading_datatable_size_ratio = 4;
        } else {
            _lazy_loading_datatable_size_ratio = 5;
        }
    }

    function _lazy_loading_datatable_ajax_request(url, page, size) {
        let _prev_lazy_loading_datatable_page_number = _lazy_loading_datatable.page.info().page;
        if (url === "") {
            return;
        }

        let params = _lazy_loading_datatable_ajax_request_query_params !== undefined && _lazy_loading_datatable_ajax_request_query_params !== "" ? "&" + _lazy_loading_datatable_ajax_request_query_params : "";

        $.ajax({
            type: "GET",
            url: url + "?page=" + page + "&size=" + size + "&query=" + _lazy_loading_datatable.search() + params,
            success: function (result, textStatus, xhr) {
                let contentType = xhr.getResponseHeader("content-type");

                if (contentType === "application/json") {
                   if (page === 1) {
                        _lazy_loading_datatable.clear();
                    }
                    _lazy_loading_datatable.rows.add(result.data).draw();
                    _prev_lazy_loading_datatable_page_number = _lazy_loading_datatable.page.info().pages > _prev_lazy_loading_datatable_page_number ? _prev_lazy_loading_datatable_page_number : 0;
                    _lazy_loading_datatable_total_size = result.totalCount;
                    _lazy_loading_datatable.page(_prev_lazy_loading_datatable_page_number).draw("page");
                } else if (contentType === "text/html;charset=ISO-8859-1" && result.match("<title>Login</title>")) {
                    location.reload();
                }
			},
			beforeSend: function() {
				$(".dataTables_processing").show();
			},
			complete: function(xhr, textStatus) {
				$(".dataTables_processing").hide();
			},
			error: function(xhr, textStatus, errorThrown) {
				console.error("Error:", errorThrown);
			}
		});
	}

    function registerPageLengthChangeEvent(datatableRef) {
        datatableRef.on("length.dt", function (e, settings, len) {
            sessionStorage.setItem("length.dt", len);
            _lazy_loading_datatable_size_ratio_by_size(len);

            if (len < _lazy_loading_datatable_page_size || (_lazy_loading_datatable_size_ratio * len) <= _lazy_loading_datatable.rows().data().length) {
                _lazy_loading_datatable_page_size = len;
                _lazy_loading_datatable_pages = _lazy_loading_datatable.page.info().pages;
                _lazy_loading_datatable_page_number = 0;
                _lazy_loading_datatable.page(_lazy_loading_datatable_page_number).draw("page");
            } else {
                _lazy_loading_datatable_page_size = len;
                _lazy_loading_datatable.clear();
                _lazy_loading_datatable_page_number = 1;
                _lazy_loading_datatable_pages = (len * _lazy_loading_datatable_size_ratio) / len;
                _lazy_loading_datatable_ajax_request(_lazy_loading_datatable_ajax_request_url, _lazy_loading_datatable_page_number, len * _lazy_loading_datatable_size_ratio);
            }
        });
    }

    function registerSearchEvent(datatableRef) {
        datatableRef.on("search.dt", function () {
            if (_lazy_loading_datatable.search().length > 2 && _lazy_loading_datatable.search() !== _lazy_loading_datatable_ajax_request_search_query) {
                if (_lazy_loading_datatable_data.length === 0) {
                    _lazy_loading_datatable_data = _lazy_loading_datatable.rows().data().toArray();
                }

                _lazy_loading_datatable_ajax_request_search_query = _lazy_loading_datatable.search();
                _lazy_loading_datatable.clear();
                _lazy_loading_datatable_ajax_request(_lazy_loading_datatable_ajax_request_url, 1, _lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio);
            } else if (_lazy_loading_datatable_ajax_request_search_query !== "" && _lazy_loading_datatable.search().length === 0) {
                _lazy_loading_datatable_ajax_request_search_query = "";
                _lazy_loading_datatable.clear();
                _lazy_loading_datatable.rows.add(_lazy_loading_datatable_data).draw();
                _lazy_loading_datatable_data = [];
            }
        });
    }

    function registerDrawEvent(datatableRef) {
        datatableRef.on("draw.dt", function () {
            let info = _lazy_loading_datatable.page.info();
            let loadDataIndex = _lazy_loading_datatable_size_ratio === 2 ? 2 : 3;

            if (_lazy_loading_datatable_pages - info.page < loadDataIndex && _lazy_loading_datatable_pages - info.page > 0) {
                if ((info.pages * _lazy_loading_datatable_page_size) === info.recordsDisplay) {
                    _lazy_loading_datatable_pages = info.pages + (_lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio) / info.length;
                    _lazy_loading_datatable_page_number = (info.recordsDisplay / (_lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio)) + 1;
                    _lazy_loading_datatable_ajax_request(_lazy_loading_datatable_ajax_request_url, _lazy_loading_datatable_page_number, _lazy_loading_datatable_page_size * _lazy_loading_datatable_size_ratio);
                }
            }
        });
    }

    function _lazy_loading_datatable_initialize_listeners(datatableRef) {
        registerPageLengthChangeEvent(datatableRef);
        registerSearchEvent(datatableRef);
        registerDrawEvent(datatableRef);
    }
})(jQuery);
