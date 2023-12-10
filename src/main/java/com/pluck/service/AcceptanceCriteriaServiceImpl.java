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

import com.pluck.dto.task.AcceptanceCriteriaDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class AcceptanceCriteriaServiceImpl implements AcceptanceCriteriaService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public AcceptanceCriteriaDto add( AcceptanceCriteriaDto dto, String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.setCompany( companyId );
		dto.setProject( defaultProjectId );
		HttpEntity<AcceptanceCriteriaDto> request = new HttpEntity<>( dto, headers );
		String url = env.getProperty( "api.criterias.add" );
		if ( url != null ) {
			try {
				ResponseEntity<AcceptanceCriteriaDto> result = restTemplate.postForEntity( url, request, AcceptanceCriteriaDto.class );
				return result.getBody();
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
			}
		}
		return null;
	}

	@Override
	public List<AcceptanceCriteriaDto> findAll( Long projectId, Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<AcceptanceCriteriaDto>> responseType = new ParameterizedTypeReference<List<AcceptanceCriteriaDto>>() {
		};

		try {
			ResponseEntity<List<AcceptanceCriteriaDto>> result = restTemplate.exchange( env.getProperty( "api.criterias.all" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

}
