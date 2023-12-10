package com.pluck.dto.task;

import java.time.LocalDate;
import java.util.List;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

import com.pluck.dto.scrum.ScrumTeamDetailsDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SprintDto {
	private Integer id;

	@Size( min = 2, max = 16 )
	@NotBlank
	private String name;

	@Size( min = 2, max = 16 )
	@NotBlank
	private String duration;

	private Long addedBy;

	private String status;

	private Long company;

	private Long project;

	private String description;

	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate startDate;

	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate lastDate;

	private List<Long> taskIds;

	private ScrumTeamDetailsDto scrumId;

	private double completedTasksWidth;

}
