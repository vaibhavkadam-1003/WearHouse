package com.pluck.dto.task;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DetailedAgileRequestDto {
	private Long id;
	private String storyType;
	private int module;
	private int sprint;
	private Long reviewedBy;
	private List<Long> acceptanceCriteria;
	private String status;
	private Long project;
	private Long company;
}
