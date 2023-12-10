package com.pluck.dto.sprint;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SprintHistoryResponseDto {
	private Long id;

	private Integer sprintId;

	private Long taskId;

	private String taskStatus;

	private Long taskAssignee;

	private Long projectId;

	private Integer storyPoints;
}
