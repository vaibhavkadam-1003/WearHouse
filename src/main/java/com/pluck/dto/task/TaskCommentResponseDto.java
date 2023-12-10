package com.pluck.dto.task;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskCommentResponseDto {

	private Long id;

	private String comment;

	private Long taskId;

	private Long companyId;

	private Long addedBy;

	private String firstName;

	private String lastName;

	private LocalDateTime addedOn;

	private String thisTimeAgo;

	private LocalDateTime updatedOn;

	private Long updatedBy;

}
