package com.pluck.dto.sprint;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SprintHistoryTaskDto {

	private String title;
	private String priority;
	private String status;
	private String story_point;
}
