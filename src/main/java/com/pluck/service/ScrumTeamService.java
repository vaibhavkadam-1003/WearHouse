package com.pluck.service;

import java.util.List;

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectUserRequestDto;
import com.pluck.dto.scrum.ScrumRequestDto;
import com.pluck.dto.scrum.ScrumTeamDetailsDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.scrum.SprintScrumTeamDetails;
import com.pluck.dto.task.TaskDto;

public interface ScrumTeamService {
	public String add( ScrumRequestDto dto, String token );

	public List<ScrumTeamResponseDto> allScrumTeams( Long companyId, Long defaultProjectId, String token );
	
	public List<ScrumTeamResponseDto> allScrumTeamsByActiveSprint( Long companyId, Long defaultProjectId, String token );

	public ScrumTeamDetailsDto findByScrumId( Long companyId, Long id, String token );

	public List<TaskDto> findTasksByProjectIdAndUserId( Long companyId, Long projectId, Long userId, String token );

	String deleteUserFromScrumTeam( Long teamId, Long userId, Long companyId, Long defaultProjectId, String token );

	public String addUsers( Long teamId, ProjectUserRequestDto dto, Long companyId, Long defaultProjectId, String token );

	public List<ScrumTeamDetailsDto> getScrumDetails( List<ScrumTeamResponseDto> scrumTeams, Long companyId, String token );

	public List<SprintScrumTeamDetails> scrumTeamDetailsForSprint( Long companyId, Long scrumId, Integer sprintId, String token );

	public String scrumTeamName( Long scrumId, String token );

	public List<UserResponseDTO> findAllScrumTeamUsersForProject( String token, Long companyId, Long defaultProjectId );

	public List<UserResponseDTO> findAllScrumMastersForProject( Long companyId, Long defaultProjectId, String token );
	
	public String deleteTeam( Long teamId, String token);
	
	public ScrumTeamDetailsDto updateTeam(ScrumRequestDto dto, String token);
}
