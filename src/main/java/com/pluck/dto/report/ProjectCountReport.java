package com.pluck.dto.report;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProjectCountReport {

	private String projectName;
	private Integer totalTasks;
	private Integer completedTasks;
	private Integer inCompleteTasks;
	private Integer totalStoryPoints;
	private Integer completedStoryPoints;
	private Integer incompleteStoryPoints;
	private Integer scrumTeams;
	private Long projectId;
	private String sprintName;
}
