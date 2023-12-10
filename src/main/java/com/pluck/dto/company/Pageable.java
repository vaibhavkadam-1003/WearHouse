package com.pluck.dto.company;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Pageable {

	public Sort sort;
	public int offset;
	public int pageSize;
	public int pageNumber;
	public boolean paged;
	public boolean unpaged;
}
