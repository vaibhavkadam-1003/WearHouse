package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QuickUserStoryResponseDto {
	private Long id;

	private String taskType;

	private String storyType;

	private TaskDto task;
}
