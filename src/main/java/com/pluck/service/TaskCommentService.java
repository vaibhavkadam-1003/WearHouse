package com.pluck.service;

import java.util.List;

import com.pluck.dto.task.CommentAttachmentResponseDto;
import com.pluck.dto.task.TaskAttachmentResponseDto;
import com.pluck.dto.task.TaskCommentDto;
import com.pluck.dto.task.TaskCommentResponseDto;

public interface TaskCommentService {
	
	public TaskCommentResponseDto addTaskComment(TaskCommentDto dto, String token);
	
	public List<TaskCommentResponseDto>  getAllTaskComment(Long taskId, Long companyId, String token);
	
	public String deleteTaskComment( Long commentId, String token, Long companyId, Long userId );
	
	public TaskCommentResponseDto updateTaskComment(TaskCommentDto dto, String token);

	public List<CommentAttachmentResponseDto> findAttachmentById(String token, Long commentId);

	public int deleteCommentFile(String token, Long id);
	
}
