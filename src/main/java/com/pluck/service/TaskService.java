package com.pluck.service;

import java.util.List;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.task.TaskAttachmentRequestDto;
import com.pluck.dto.task.TaskAttachmentResponseDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.dto.task.TaskPagerDto;
import com.pluck.utilites.StatusWrapper;

public interface TaskService {

	public List<String> getPriorities( String token );

	public List<String> getSeverties( String token );

	public String addTask( TaskDto dto, String token, Long companyId, Long defaultProjectId, LoginUserDto loggedInUser );

	public TaskPagerDto allUserTask( String token, Integer pageNo, int pageSize, Long companyId, Long projectId );

	public TaskPagerDto allTaskByActiveSprint( String token, int pageNo, Long companyId, Long projectId );

	public TaskPagerDto allTaskByProject( String token, int pageNo, Long companyId, Long projectId );

	public List<String> getTaskStatus( String token );

	public TaskDto findTaskById( String token, Long taskId, Long companyId, Long defaultProjectId );

	public String updateTask( TaskDto dto, String token, Long companyId, Long defaultProjectId );

	public String updateTaskAttachmentsModal( TaskDto dto, String token );

	public String updateTaskModal( TaskDto dto, String token, Long companyId, Long defaultProjectId );

	public List<TaskDto> getAllIncompleteTasks( String token, Long companyId, Long projectId );

	public List<TaskDto> getAllIncompleteTasksToStartSprint( String token, Long companyId, Long projectId );

	public TaskPagerDto findTaskByStatus( StatusWrapper status, String token, Long companyId, Long defaultProjectId, int pageNo );

	public int deleteTask( String token, Long id, Long userId, Long companyId );

	TaskDto updateTask1( TaskDto dto, String token, Long companyId, Long defaultProjectId );

	public List<TaskAttachmentResponseDto> findAttachmentById( String token, Long taskId );

	public int getTaskCount( String token, Long companyId, Long defaultProjectId );

	public List<TaskDto> getTop5TasksByUser( String token, Long loggedInUserId, Long defaultProjectId, Long companyId );

	public TaskPagerDto getAllTasksByUser( String token, Long id, Long defaultProjectId, Long companyId, int pageNo );

	public int countAllTasksByCompany( Long companyId, String token );

	public List<TaskDto> findTop5TasksByProject( Long companyId, Long projectId, String token );

	public TaskPagerDto getAllTaskByUser( String attribute, int pageNo, Long companyId, Long projectId, Long selectedUserId );

	public List<String> getTaskType( String token );

	public TaskPagerDto getAllCompletedTask( String token, int pageNo, Long companyId, Long projectId );

	public TaskPagerDto getAllInCompleteTask( String token, int pageNo, Long companyId, Long projectId );

	public List<TaskDto> TaskFilter( Long project, String status, String token );

	public String addTaskAttachment( TaskAttachmentRequestDto taskAttachmentRequestDto, String token );

	public List<StatusConfigurationDto> statusDropdownGenerator( String token, String currentStatus, Long defaultProjectId, Long companyId );

	public String getStatusById( String token, Long id, Long companyId, Long defaultProjectId );

	public List<TaskDto> findAllBacklogTasks( String token, Long companyId, Long defaultProjectId );

	public String updateTaskStatus( Long taskId, String status );

	public TaskPagerDto allTasksBySearchQuery( String token, Integer pageNo, int pageSize, String searchQuery, Long companyId, Long projectId );
}