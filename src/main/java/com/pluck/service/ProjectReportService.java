package com.pluck.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.report.SprintReportRequestDto;
import com.pluck.dto.report.TaskReportRequestDto;
import com.pluck.dto.task.Content;
import com.pluck.dto.task.TaskDto;

public interface ProjectReportService {

	List<Content> allUserTask( String token, Long companyId, Long projectId );

	List<TaskDto> findCompletedTasksByProject( String token, Long companyId, Long defaultProjectId );

	List<TaskDto> findInCompletedTasksByProject( String token, Long companyId, Long defaultProjectId );

	Set<UserResponseDTO> allUsersByProject( Long defaultProjectId, Long companyId, String attribute );

	Integer countAllScrumTeams( Long companyId, Long defaultProjectId, String token );

	Integer countAllActiveSprint( Long companyId, Long defaultProjectId, String token );

	Integer countAllInactiveSprint( Long companyId, Long defaultProjectId, String token );

	Map<String, Integer> findStoryPointCountForProject( Long companyId, Long defaultProjectId, String token );

	ProjectResponseDto findById( Long defaultProjectId, String attribute );

	//	New methods started

	public List<TaskDto> generateTaskReport( TaskReportRequestDto dto, String token );

	List<TaskDto> generateActiveSprintReport( SprintReportRequestDto dto, String token );

}