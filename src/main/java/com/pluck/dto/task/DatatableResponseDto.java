package com.pluck.dto.task;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DatatableResponseDto {

	public List<Content> data;
	private int totalCount;
	private int recordsFiltered;
}
