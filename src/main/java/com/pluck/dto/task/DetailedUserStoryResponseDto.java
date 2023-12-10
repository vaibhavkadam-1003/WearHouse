package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DetailedUserStoryResponseDto {
	private TaskDto task;
	private DetailedAgileResponseDto agile;
}
