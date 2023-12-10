package com.pluck.dto.scrum;

import java.util.List;

import com.pluck.dto.task.TaskDto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SprintScrumTeamDetails {
	private Long id;
	private String user;
	private List<TaskDto> tasks;
}
