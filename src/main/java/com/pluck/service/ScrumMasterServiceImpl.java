package com.pluck.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.report.ProjectCountReport;
import com.pluck.dto.scrum.ScrumTeamResponseDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ScrumMasterServiceImpl implements ScrumMasterService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public Map<String, List<ScrumTeamResponseDto>> findAllScrumTeamsForScrumMaster( Long companyId, Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, List<ScrumTeamResponseDto>>> responseType = new ParameterizedTypeReference<Map<String, List<ScrumTeamResponseDto>>>() {
		};
		try {
			ResponseEntity<Map<String, List<ScrumTeamResponseDto>>> result = restTemplate.exchange( env.getProperty( "api.scrum.master.scrum.teams" ) + companyId + "/" + id, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, Integer> findTaskCountForProject( Long companyId, Long defaultProjectId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};
		try {
			ResponseEntity<Map<String, Integer>> result = restTemplate.exchange( env.getProperty( "api.task.report.tasks.count" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, Integer> findStoryPointCountForProject( Long companyId, Long projectId, String token ) {

		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};
		try {
			ResponseEntity<Map<String, Integer>> result = template.exchange( env.getProperty( "api.task.report.story.point.count" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public ProjectCountReport findCountReportByProject( Long companyId, Long projectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<ProjectCountReport> result = restTemplate.exchange( env.getProperty( "api.task.report.project.count" ) + companyId + "/" + projectId, HttpMethod.GET, entity, ProjectCountReport.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<ProjectCountReport> findProjectCountReportByScrumMaster( Long companyId, Long userId, String token ) {

		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ProjectCountReport>> responseType = new ParameterizedTypeReference<List<ProjectCountReport>>() {
		};
		try {
			ResponseEntity<List<ProjectCountReport>> result = template.exchange( env.getProperty( "api.task.report.project.scrum.master.count" ) + companyId + "/" + userId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, List<ScrumTeamResponseDto>> findAllScrumTeamsForUser( Long companyId, Long id, String token ) {

		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, List<ScrumTeamResponseDto>>> responseType = new ParameterizedTypeReference<Map<String, List<ScrumTeamResponseDto>>>() {
		};
		try {
			ResponseEntity<Map<String, List<ScrumTeamResponseDto>>> result = template.exchange( env.getProperty( "api.user.scrum.teams" ) + companyId + "/" + id, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, Integer> findTaskCountForUser( Long companyId, Long projectId, Long selectedUserId, String token ) {

		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};
		try {
			ResponseEntity<Map<String, Integer>> result = template.exchange( env.getProperty( "api.task.user.report.tasks.count" ) + companyId + "/" + projectId + "/" + selectedUserId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, Integer> findStoryPointCountForUser( Long companyId, Long projectId, Long selectedUserId, String token ) {
		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};

		try {
			ResponseEntity<Map<String, Integer>> result = template.exchange( env.getProperty( "api.task.user.report.story.count" ) + companyId + "/" + projectId + "/" + selectedUserId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<ScrumTeamResponseDto> findAllScrumTeamsForProject( Long companyId, Long project, String token ) {

		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ScrumTeamResponseDto>> responseType = new ParameterizedTypeReference<List<ScrumTeamResponseDto>>() {
		};
		try {
			ResponseEntity<List<ScrumTeamResponseDto>> result = template.exchange( env.getProperty( "api.project.scrum.teams" ) + companyId + "/" + project, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

}
