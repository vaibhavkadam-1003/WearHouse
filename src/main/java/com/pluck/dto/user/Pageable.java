package com.pluck.dto.user;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Pageable {
	private Sort sort;
	private int offset;
	private int pageSize;
	private int pageNumber;
	private boolean unpaged;
	private boolean paged;

}
