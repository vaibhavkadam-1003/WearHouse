package com.pluck.dto.sprint;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StartSprintRequestDto {
	private Long companyId;
	private Integer sprintId;
	private Long scrumTeams;
	private Long projectId;
	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate startDate;

	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate lastDate;
}
