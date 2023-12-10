package com.pluck.dto.task;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskDto {
	private Long id;

	private String taskType;

	@Size( min = 2, max = 255 )
	@NotBlank
	private String title;

	private String description;

	@NotBlank
	private Long assignedTo;

	private String assigneName;

	private String priority;

	private String severity;

	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate startDate;

	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate lastDate;

	private Long project;

	private String projectName;

	private Long company;

	private String status;

	private int sprint;

	private List<MultipartFile> files;

	private String ticket;

	private Long loggedInUserId;

	private String firstName;

	private String lastName;

	private String story_point;

	private Long addedBy;

	private Long updatedBy;

	private String originalEstimate;

	private String timeTracking;

	private LocalDateTime addedOn;

	private String reporter;
}