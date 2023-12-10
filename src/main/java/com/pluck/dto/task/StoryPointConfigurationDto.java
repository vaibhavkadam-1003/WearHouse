package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class StoryPointConfigurationDto {

	private Long id;

	private Long company;

	private Long project;

	private String storyPoint;

	private Integer range;

	private String status;

}
