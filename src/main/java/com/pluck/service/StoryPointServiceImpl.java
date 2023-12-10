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

import com.pluck.dto.task.StoryPointConfigurationDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class StoryPointServiceImpl implements StoryPointService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<StoryPointConfigurationDto> findAll( String token, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<StoryPointConfigurationDto>> responseType = new ParameterizedTypeReference<List<StoryPointConfigurationDto>>() {
		};
		try {
			ResponseEntity<List<StoryPointConfigurationDto>> result = restTemplate.exchange(
					env.getProperty( "api.story.all" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String add( List<StoryPointConfigurationDto> dto, String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );

		for ( StoryPointConfigurationDto storyPoint : dto ) {
			Long company = companyId;
			Long project = defaultProjectId;
			storyPoint.setCompany( company );
			storyPoint.setProject( project );
		}
		HttpEntity<List<StoryPointConfigurationDto>> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.story.add" ), request,
					String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable To Add storyPoints";
	}

}