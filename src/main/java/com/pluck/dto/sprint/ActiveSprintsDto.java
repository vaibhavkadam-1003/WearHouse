package com.pluck.dto.sprint;

import java.util.List;

import com.pluck.dto.task.SprintDto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ActiveSprintsDto {
	private Long projectId;
	private String project;
	private List<SprintDto> sprint;
}
