package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class QuickUserStoryRequestDto {
	private TaskDto task;
	private AgileRequestDto agile;
}
