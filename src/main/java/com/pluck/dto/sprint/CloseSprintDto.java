package com.pluck.dto.sprint;

import java.util.HashMap;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CloseSprintDto {
	private Long companyId;
	private Long projectId;
	private Integer sprintId;
	private boolean allTaskToDelete;
	private List<Long> taskIdsToDelete;
	private HashMap<String, List<Long>> newSprintTasks;
}
