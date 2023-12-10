package com.pluck.dto.sprint;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SprintUserChartDetailsDto {
	private Long id;
	private String name;
	private Integer totalStoryPoints;
	private Integer completedStoryPoints;
	private Integer incompleteStoryPoints;
}
