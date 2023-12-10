package com.pluck.service;

import java.util.Arrays;

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

import com.pluck.dto.task.DetailedUserStoryRequestDto;
import com.pluck.dto.task.DetailedUserStoryResponseDto;
import com.pluck.dto.task.QuickStoryPaginationResponse;
import com.pluck.dto.task.QuickUserStoryRequestDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class UserStoryServiceImpl implements UserStoryService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public String addQuickStory( QuickUserStoryRequestDto dto, String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.getAgile().setProject( defaultProjectId );
		dto.getAgile().setCompany( companyId );
		HttpEntity<QuickUserStoryRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.user.story.add" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to add user story";
	}

	@Override
	public String addDetailedStory( DetailedUserStoryRequestDto dto, String token, Long companyId, Long defaultProjectId, String firstName, String lastName, Long loggedInuserId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.getAgile().setProject( defaultProjectId );
		dto.getAgile().setCompany( companyId );
		dto.getTask().setFirstName( firstName );
		dto.getTask().setLastName( lastName );
		dto.getTask().setLoggedInUserId( loggedInuserId );
		HttpEntity<DetailedUserStoryRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.story.detailed.add" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to add user story";
	}

	@Override
	public QuickStoryPaginationResponse allUserStories( String token, int pageNo, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<QuickStoryPaginationResponse> responseType = new ParameterizedTypeReference<QuickStoryPaginationResponse>() {
		};
		try {
			ResponseEntity<QuickStoryPaginationResponse> result = restTemplate.exchange( env.getProperty( "api.user.story.all" ) + companyId + "/" + projectId + "?pageNo=" + pageNo, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public DetailedUserStoryResponseDto findUserStoryById( String token, Long storyId, Long companyId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<DetailedUserStoryResponseDto> result = restTemplate.exchange( env.getProperty( "api.user.story.by.id" ) + companyId + "/" + storyId, HttpMethod.GET, entity, DetailedUserStoryResponseDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String updateQuickStory( QuickUserStoryRequestDto dto, String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.getAgile().setProject( defaultProjectId );
		dto.getAgile().setCompany( companyId );
		HttpEntity<QuickUserStoryRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.user.story.update" ), HttpMethod.PUT, request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to update user story";
	}

	@Override
	public int getUserStoryCount( String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.user.story.count" ) + companyId + "/" + defaultProjectId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public int countAllStoryByCompany( Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Integer> responseType = new ParameterizedTypeReference<Integer>() {
		};
		try {
			ResponseEntity<Integer> result = restTemplate.exchange(
					env.getProperty( "api.company.stories.count" ) + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}
}
