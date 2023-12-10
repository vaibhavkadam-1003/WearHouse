package com.pluck.service;

import java.util.List;
import java.util.Map;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.sprint.ActiveSprintsDto;
import com.pluck.dto.sprint.CloseSprintDto;
import com.pluck.dto.sprint.SprintHistoryResponseDto;
import com.pluck.dto.sprint.SprintHistoryTaskDto;
import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.sprint.StartSprintRequestDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;

public interface SprintService {

	public String addSprint( SprintDto dto, String token, LoginUserDto loggedInUser, Long defaultProjectId );

	public List<SprintDto> findAll( String token, Long companyId, Long projectId );

	public Map<String, List<TaskDto>> findTasksBySprint( String token, Long companyId, Long projectId, int sprintId );

	public List<SprintDto> findAvailableSprints( String token, Long companyId, Long defaultProjectId );

	public String startSprint( String token, StartSprintRequestDto dto );

	public SprintDto findCurrentSprint( String token, Long companyId, Long projectId );

	public Map<String, Integer> findSprintInfo( String token, Long companyId, Long defaultProjectId, Integer sprintId );

	public String closeSprint( String token, Long companyId, Long defaultProjectId, Integer id, CloseSprintDto dto );

	public TaskDto addTaskToSprint( String token, Long id, Integer sprintId );

	public List<SprintDto> findPreviousSprints( String token, Long companyId, Long defaultProjectId );

	public List<SprintHistoryResponseDto> findHistoryById( String token, Long defaultProjectId, Integer id );

	public List<SprintUserChartDetailsDto> findCurrentSprintUserChartDetails( Long companyId, Long defaultProjectId, Integer currentSprint, String token );

	public List<ScrumTeamResponseDto> findScrumTeamForSprint( Long companyId, Integer sprintId, String token );

	public List<TaskDto> currentSprintAllTasks( Long companyId, Long defaultProjectId, Integer currentSprint, String token );

	public String addScrumToSprint( String token, StartSprintRequestDto dto );

	public List<SprintHistoryTaskDto> sprintAllTasksHistory( Long companyId, Long defaultProjectId, Integer sprintId, String token );

	public Map<String, List<TaskDto>> findTasksByProjects( String token, Long companyId, Long defaultProjectId );

	public List<SprintUserChartDetailsDto> findCurrentProjectUserChartDetails( Long companyId, Long defaultProjectId,
			String token );

	public String findName( int sprintId, String token );

	public List<TaskDto> findSprintTasks( Integer sprintId, String status, String token );

	public List<TaskDto> currentSprintTaskFilter( Integer currentSprint, String status, String token );

	public List<SprintUserChartDetailsDto> findSprintHistoryUserChartDetails( Long companyId, Long defaultProjectId, Integer currentSprint, String token );

	public List<TaskDto> sprintHistoryTaskFilter( Integer sprintId, String status, String token );

	public List<ActiveSprintsDto> findActiveSprintsForUser( Long companyId, Long id, String token );

	public SprintDto findById( Integer sprintId, String token );

	public Long countByAndScrumIdAndStatus( Long list, String token );

	public List<SprintDto> findActiveSprints( String token, Long companyId, Long defaultProjectId );

	public SprintDto findCurrentActiveSprint( String token, Long companyId, Long defaultProjectId, Integer id );

	public List<SprintDto> findBacklogActiveSprints( String token, Long companyId, Long projectId );
}
