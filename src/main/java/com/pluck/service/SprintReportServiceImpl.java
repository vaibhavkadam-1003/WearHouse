package com.pluck.service;

import java.util.Arrays;
import java.util.List;

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

import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@AllArgsConstructor
public class SprintReportServiceImpl implements SprintReportService {

	@Autowired
	private final Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<SprintUserChartDetailsDto> currentSprintUserReport( Long companyId, Long defaultProjectId,
			Integer currentSprint, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintUserChartDetailsDto>> responseType = new ParameterizedTypeReference<List<SprintUserChartDetailsDto>>() {
		};
		try {
			ResponseEntity<List<SprintUserChartDetailsDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.current.user.report" ) + companyId + "/" + defaultProjectId + "/" + currentSprint, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskDto> findCompletedTasksBySprint( String token, Long companyId, Long projectId,
			Integer sprintId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.tasks.completed" ) + companyId + "/" + projectId + "/" + sprintId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskDto> findInCompletedTasksBySprint( String token, Long companyId, Long projectId,
			Integer sprintId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.tasks.incompleted" ) + companyId + "/" + projectId + "/" + sprintId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<SprintDto> findAllSprintsByCompanyAndProject( String token, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintDto>> responseType = new ParameterizedTypeReference<List<SprintDto>>() {
		};
		try {
			ResponseEntity<List<SprintDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.all.by.project" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String findBySprintNameById( Integer Id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<String> responseType = new ParameterizedTypeReference<String>() {
		};
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.sprint.name" ) + Id,
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public Integer countByTotalTasks( Long companyId, Long defaultProjectId, Integer sprintId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.sprint.task.count" ) + companyId + "/" + defaultProjectId + "/" + sprintId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;
	}

	@Override
	public Integer countAllCompletedTasks( Long companyId, Long projectId, Integer sprintId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.sprint.task.completed.count" ) + companyId + "/" + projectId + "/" + sprintId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;
	}
}
