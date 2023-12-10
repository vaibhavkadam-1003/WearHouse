package com.pluck.controller;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.pluck.constants.Constants;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.task.StoryPointConfigurationDto;

@Component
public class DropdownCache {

	@Autowired
	private RestTemplate template;

	@Autowired
	private Environment env;

	public Map<Long, List<StoryPointConfigurationDto>> storyPoints = null;
	public Map<Long, List<PriorityConfigurationDto>> priorities = null;
	public Map<Long, List<SeverityConfigurationDto>> severities = null;
	public Map<Long, List<StatusConfigurationDto>> status = null;

	public void loadStoryPoints( Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<Long, List<StoryPointConfigurationDto>>> responseType = new ParameterizedTypeReference<Map<Long, List<StoryPointConfigurationDto>>>() {
		};
		ResponseEntity<Map<Long, List<StoryPointConfigurationDto>>> result = template.exchange( env.getProperty( "api.dropdown.story.points" ) + companyId, HttpMethod.GET, entity, responseType );
		storyPoints = result.getBody();
	}

	public List<StoryPointConfigurationDto> getStoryPoints( Long projectId ) {
		if ( storyPoints != null && storyPoints.size() > 0 ) {
			return storyPoints.get( projectId );
		}
		return Collections.emptyList();
	}

	public List<PriorityConfigurationDto> getPriorities( Long projectId ) {
		if ( priorities != null && priorities.size() > 0 ) {
			List<PriorityConfigurationDto> x = priorities.get( projectId );
			if ( x == null ) {
				return priorities.get( 0l );
			}
			return x;
		}
		return Collections.emptyList();
	}

	public void loadPriorites( Long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<Long, List<PriorityConfigurationDto>>> responseType = new ParameterizedTypeReference<Map<Long, List<PriorityConfigurationDto>>>() {
		};

		ResponseEntity<Map<Long, List<PriorityConfigurationDto>>> result = template.exchange( env.getProperty( "api.dropdown.priorities" ) + companyId, HttpMethod.GET, entity, responseType );
		priorities = result.getBody();
	}

	public List<SeverityConfigurationDto> getSeverities( Long defaultProjectId ) {
		if ( severities != null && severities.size() > 0 ) {
			List<SeverityConfigurationDto> x = severities.get( defaultProjectId );
			if ( x == null ) {
				return severities.get( 0l );
			}
			return x;
		}
		return Collections.emptyList();
	}

	public void loadSeverities( Long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<Long, List<SeverityConfigurationDto>>> responseType = new ParameterizedTypeReference<Map<Long, List<SeverityConfigurationDto>>>() {
		};

		ResponseEntity<Map<Long, List<SeverityConfigurationDto>>> result = template.exchange( env.getProperty( "api.dropdown.severities" ) + companyId, HttpMethod.GET, entity, responseType );
		severities = result.getBody();
	}

	public List<StatusConfigurationDto> getStatuses( Long defaultProjectId ) {
		if ( status != null && status.size() > 0 ) {
			List<StatusConfigurationDto> x = status.get( defaultProjectId );
			if ( x == null ) {
				return status.get( 0l );
			}
			return x;
		}
		return Collections.emptyList();
	}

	public void loadStatus( Long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<Long, List<StatusConfigurationDto>>> responseType = new ParameterizedTypeReference<Map<Long, List<StatusConfigurationDto>>>() {
		};

		ResponseEntity<Map<Long, List<StatusConfigurationDto>>> result = template.exchange( env.getProperty( "api.dropdown.status" ) + companyId, HttpMethod.GET, entity, responseType );
		status = result.getBody();
	}
}