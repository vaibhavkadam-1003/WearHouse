package com.pluck.dto.task;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskCommentDto {
	private Long id;
	
	private String comment;
	
	private Long taskId;
	
	private Long companyId;
	
	private Long addedBy;
	
	private LocalDateTime addedOn;
	
	private String dateTimeString;
	
	private LocalDateTime updatedOn;
	
	private Long updatedBy;
	
	private List<MultipartFile> commentFiles;
	
}
