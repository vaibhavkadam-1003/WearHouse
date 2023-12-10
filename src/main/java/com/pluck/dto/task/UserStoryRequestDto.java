package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserStoryRequestDto {
	private String title;
	private String description;
	private String type;
	private String assignedTo;
	private String priority;
}
