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

import com.pluck.dto.query.QueryBuilderTaskResponseDto;
import com.pluck.dto.query.QueryDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class QueryServiceImpl implements QueryService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<QueryBuilderTaskResponseDto> query( QueryDto dto, Long projectId ) {

		dto.setProjectId( projectId );
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<QueryDto> entity = new HttpEntity<>( dto, headers );
		ParameterizedTypeReference<List<QueryBuilderTaskResponseDto>> responseType = new ParameterizedTypeReference<List<QueryBuilderTaskResponseDto>>() {
		};
		try {
			ResponseEntity<List<QueryBuilderTaskResponseDto>> result = restTemplate.exchange( env.getProperty( "api.query.builder" ), HttpMethod.POST, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

}
