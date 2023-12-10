package com.pluck.dto.report;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskReportRequestDto {
	private Long projectId;
	private Integer sprintId;
	private Long userId;
	private String taskStatus;
	private Long companyId;

	@DateTimeFormat( pattern = "yyyy-MM-dd'T'HH:mm" )
	private LocalDateTime fromDate;

	@DateTimeFormat( pattern = "yyyy-MM-dd'T'HH:mm" )
	private LocalDateTime toDate;
}
