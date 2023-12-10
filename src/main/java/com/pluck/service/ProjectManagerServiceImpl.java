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

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.scrum.ScrumTeamResponseDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ProjectManagerServiceImpl implements ProjectManagerService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public Map<String, List<ScrumTeamResponseDto>> findAllScrumTeamsByProjectManager( Long companyId, Long projectManagerId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, List<ScrumTeamResponseDto>>> responseType = new ParameterizedTypeReference<Map<String, List<ScrumTeamResponseDto>>>() {
		};
		try {
			ResponseEntity<Map<String, List<ScrumTeamResponseDto>>> result = restTemplate.exchange( env.getProperty( "api.project.manager.scrum.teams" ) + companyId + "/" + projectManagerId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<UserResponseDTO> findScrumMastersByProjectManager( Long companyId, Long projectManagerId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<UserResponseDTO>> responseType = new ParameterizedTypeReference<List<UserResponseDTO>>() {
		};
		try {
			ResponseEntity<List<UserResponseDTO>> result = restTemplate.exchange( env.getProperty( "api.user.project.manager.scrum.masters" ) + companyId + "/" + projectManagerId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

}
