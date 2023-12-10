package com.pluck.dto.query;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryBuilderTaskResponseDto {
	private Long id;
	private String title;
	private String priority;
	private Long assignedTo;
	private String storyPoints;
	private String status;
	private String taskType;
	private String ticket;
	private String assigneName;
	private String reporter;
}
