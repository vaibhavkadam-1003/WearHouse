package com.pluck.dto.task;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserStoryResponseDto {
	private int id;

	private String title;

	private String description;

	private String taskType;

	private String storyType;

	private String priority;

	private String assignedTo;
}
