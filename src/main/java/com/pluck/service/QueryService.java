package com.pluck.service;

import java.util.List;

import com.pluck.dto.query.QueryBuilderTaskResponseDto;
import com.pluck.dto.query.QueryDto;

public interface QueryService {

	public List<QueryBuilderTaskResponseDto> query( QueryDto dto, Long defaultProjectId );
}
