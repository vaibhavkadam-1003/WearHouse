package com.pluck.dto.task;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Content {
	public int id;
	public String taskType;
	public String title;
	public String description;
	public int assignedTo;
	public String assigneName;
	public String priority;
	public String severity;
	public LocalDate startDate;
	public LocalDate lastDate;
	public String status;
	private String ticket;
	private String story_point;
	public String reporter;
}
