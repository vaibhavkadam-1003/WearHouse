package com.pluck.service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectUserRequestDto;
import com.pluck.dto.scrum.ScrumRequestDto;
import com.pluck.dto.scrum.ScrumTeamDetailsDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.scrum.SprintScrumTeamDetails;
import com.pluck.dto.task.TaskDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ScrumTeamServiceImpl implements ScrumTeamService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public String add( ScrumRequestDto dto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );

		HttpEntity<ScrumRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.scrum.team.add" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to add scrum team";
	}

	@Override
	public List<ScrumTeamResponseDto> allScrumTeams( Long companyId, Long defaultProjectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ScrumTeamResponseDto>> responseType = new ParameterizedTypeReference<List<ScrumTeamResponseDto>>() {
		};
		try {
			ResponseEntity<List<ScrumTeamResponseDto>> result = restTemplate.exchange( env.getProperty( "api.scrum.team" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<ScrumTeamResponseDto> allScrumTeamsByActiveSprint( Long companyId, Long defaultProjectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ScrumTeamResponseDto>> responseType = new ParameterizedTypeReference<List<ScrumTeamResponseDto>>() {
		};
		ResponseEntity<List<ScrumTeamResponseDto>> result = restTemplate.exchange( env.getProperty( "api.scrum.team.by.active.sprint" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
		return result.getBody();
	}

	@Override
	public ScrumTeamDetailsDto findByScrumId( Long companyId, Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<ScrumTeamDetailsDto> result = restTemplate.exchange( env.getProperty( "api.scrum.team.by.id" ) + id, HttpMethod.GET, entity, ScrumTeamDetailsDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> findTasksByProjectIdAndUserId( Long companyId, Long projectId, Long userId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.scrum.team.user.task" ) + companyId + "/" + projectId + "/" + userId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String deleteUserFromScrumTeam( Long teamId, Long userId, Long companyId, Long defaultProjectId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> request = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.scrum.team.user.delete.by.id" ) + teamId + "/" + userId + "/" + companyId + "/" + defaultProjectId, HttpMethod.DELETE, request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to remove user";
	}

	@Override
	public String addUsers( Long teamId, ProjectUserRequestDto dto, Long companyId, Long defaultProjectId,
			String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );

		HttpEntity<ProjectUserRequestDto> entity = new HttpEntity<>( dto, headers );
		try {
			return restTemplate.exchange( env.getProperty( "api.scrum.team.user.add" ) + teamId + "/" + companyId + "/" + defaultProjectId, HttpMethod.PUT, entity, String.class )
					.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<ScrumTeamDetailsDto> getScrumDetails( List<ScrumTeamResponseDto> scrumTeams, Long companyId, String token ) {
		return scrumTeams.parallelStream().map( team -> {
			return findByScrumId( companyId, team.getId(), token );
		} ).collect( Collectors.toList() );
	}

	@Override
	public List<SprintScrumTeamDetails> scrumTeamDetailsForSprint( Long companyId, Long scrumId, Integer sprintId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintScrumTeamDetails>> responseType = new ParameterizedTypeReference<List<SprintScrumTeamDetails>>() {
		};
		try {
			ResponseEntity<List<SprintScrumTeamDetails>> result = restTemplate.exchange( env.getProperty( "api.scrum.team.sprint.history.team.details" ) + scrumId + "/" + sprintId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String scrumTeamName( Long scrumId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.scrum.team.name" ) + scrumId, HttpMethod.GET, entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<UserResponseDTO> findAllScrumTeamUsersForProject( String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<UserResponseDTO>> responseType = new ParameterizedTypeReference<List<UserResponseDTO>>() {
		};
		try {
			ResponseEntity<List<UserResponseDTO>> result = restTemplate.exchange( env.getProperty( "api.scrum.team.users.details" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<UserResponseDTO> findAllScrumMastersForProject( Long companyId, Long defaultProjectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<UserResponseDTO>> responseType = new ParameterizedTypeReference<List<UserResponseDTO>>() {
		};
		String url = env.getProperty( "api.user.get.scrum.master.by.project" ) + defaultProjectId;
		try {
			ResponseEntity<List<UserResponseDTO>> result = restTemplate.exchange( url, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}
	
	@Override
	public String deleteTeam(Long teamId, String token) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.scrum.team.delete" ) + teamId, HttpMethod.GET, entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}
	
	@Override
	public ScrumTeamDetailsDto updateTeam(ScrumRequestDto dto, String token) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<ScrumRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<ScrumTeamDetailsDto> result = restTemplate.exchange( env.getProperty( "api.scrum.team.update" ), HttpMethod.PUT, request, ScrumTeamDetailsDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}


}
