package com.pluck.dto.task;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentAttachmentRequestDto {
	
	@JsonIgnore
	private List<MultipartFile> files;
	
	private Long taskId;
	
	private Long commentId;
}
