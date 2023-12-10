package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TaskAttachmentResponseDto {

	private long id;
	private String docUrl;
	private String docType;
	private String docFileName;
}