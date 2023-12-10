package com.pluck.dto.task;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskHistoryResponseDto {
	
	private long id;

	private String action;	

	private long companyId;	

	private String field;	

	private String fromValue;	

	private LocalDateTime addedOn;	

	private String toValue;	

	private Long userId;

	private Long taskId;
	
	private String firstName;
	
	private String lastName;
	
	private String thisTimeAgo;
	
}
