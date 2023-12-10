package com.pluck.service;

import java.util.List;

import com.pluck.dto.task.TaskHistoryResponseDto;

public interface TaskHistoryService {
	
	public List<TaskHistoryResponseDto> getTaskHistory(Long taskId, String token);
	
}
