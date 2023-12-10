package com.pluck.utilites;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StatusWrapper {
	private List<String> status;
	private Long companyId;
	private Long defaultProjectId;
	private String type;
}
