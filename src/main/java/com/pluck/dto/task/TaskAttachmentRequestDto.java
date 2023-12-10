package com.pluck.dto.task;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskAttachmentRequestDto {
	private List<MultipartFile> files;

	private Long taskId;

	private Long companyId;
	
	private Long userId;
}