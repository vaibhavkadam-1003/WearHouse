package com.pluck.dto.query;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class QueryDto {

	private String operation;
	private String queryField;
	private StringBuilder query;
	private Long projectId;
}
