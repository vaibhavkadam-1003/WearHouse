package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DetailedUserStoryRequestDto {
	private TaskDto task;
	private DetailedAgileRequestDto agile;
}
