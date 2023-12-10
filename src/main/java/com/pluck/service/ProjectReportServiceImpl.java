package com.pluck.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.report.SprintReportRequestDto;
import com.pluck.dto.report.TaskReportRequestDto;
import com.pluck.dto.task.Content;
import com.pluck.dto.task.TaskDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ProjectReportServiceImpl implements ProjectReportService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<Content> allUserTask( String token, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<Content>> responseType = new ParameterizedTypeReference<List<Content>>() {
		};
		try {
			ResponseEntity<List<Content>> result = restTemplate.exchange(
					env.getProperty( "api.project.task.all" ) + companyId + "/" + projectId,
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return new ArrayList<Content>();
	}

	@Override
	public List<TaskDto> findCompletedTasksByProject( String token, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.project.tasks.completed" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return new ArrayList<TaskDto>();
	}

	@Override
	public List<TaskDto> findInCompletedTasksByProject( String token, Long companyId, Long projectId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.project.tasks.incompleted" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public Set<UserResponseDTO> allUsersByProject( Long defaultProjectId, Long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Set<UserResponseDTO>> responseType = new ParameterizedTypeReference<Set<UserResponseDTO>>() {
		};
		try {
			ResponseEntity<Set<UserResponseDTO>> result = restTemplate.exchange( env.getProperty( "api.project.users" ) + defaultProjectId + "/" + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return new HashSet<UserResponseDTO>();
	}

	@Override
	public Integer countAllScrumTeams( Long companyId, Long projectId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.project.scrum.count" ) + companyId + "/" + projectId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;
	}

	@Override
	public Integer countAllActiveSprint( Long companyId, Long projectId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.project.active.sprint.count" ) + companyId + "/" + projectId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;
	}

	@Override
	public Integer countAllInactiveSprint( Long companyId, Long projectId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.project.Inactive.sprint.count" ) + companyId + "/" + projectId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;
	}

	@Override
	public Map<String, Integer> findStoryPointCountForProject( Long companyId, Long projectId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};
		try {
			ResponseEntity<Map<String, Integer>> result = restTemplate.exchange( env.getProperty( "api.project.task.report.story.point.count" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public ProjectResponseDto findById( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		final String baseUrl = env.getProperty( "api.project.task.report.project.by.id" ) + id;
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<ProjectResponseDto> result = restTemplate.exchange( baseUrl, HttpMethod.GET, entity,
					ProjectResponseDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> generateTaskReport( TaskReportRequestDto dto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<TaskReportRequestDto> entity = new HttpEntity<>( dto, headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.project.task.report.all" ), HttpMethod.POST, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskDto> generateActiveSprintReport( SprintReportRequestDto dto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<SprintReportRequestDto> entity = new HttpEntity<>( dto, headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			String url = env.getProperty( "api.project.active.sprint.report.all" );
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( url, HttpMethod.POST, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

}