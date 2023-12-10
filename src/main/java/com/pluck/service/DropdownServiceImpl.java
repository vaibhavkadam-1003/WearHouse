package com.pluck.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
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

import com.pluck.constants.Constants;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DropdownServiceImpl implements DropdownService {

	@Autowired
	private RestTemplate restTemplate;

	@Autowired
	private Environment env;

	@Override
	public List<PriorityConfigurationDto> savePriority( PriorityConfigurationDto dto, String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		String priString = dto.getPriority();
		String[] str = priString.split( "," );
		List<PriorityConfigurationDto> list = new ArrayList<>();
		for ( int i = 0; i < str.length; i++ ) {
			PriorityConfigurationDto temp = new PriorityConfigurationDto();
			temp.setPriority( str[ i ] );
			temp.setProject( defaultProjectId );
			temp.setCompany( companyId );
			list.add( temp );
		}

		HttpEntity<List<PriorityConfigurationDto>> request = new HttpEntity<>( list, headers );
		ParameterizedTypeReference<List<PriorityConfigurationDto>> responseType = new ParameterizedTypeReference<List<PriorityConfigurationDto>>() {
		};
		String url = env.getProperty( "api.priorities.add" );
		if ( url != null ) {
			try {
				ResponseEntity<List<PriorityConfigurationDto>> result = restTemplate.exchange( url, HttpMethod.POST, request, responseType );
				return result.getBody();
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
			}
		}
		return Collections.emptyList();
	}

	@Override
	public Long delete( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = restTemplate.exchange( env.getProperty( "api.priorities.delete.by.id" ) + id, HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SeverityConfigurationDto> saveSeverity( SeverityConfigurationDto dto, String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		String priString = dto.getSeverity();
		String[] str = priString.split( "," );
		List<SeverityConfigurationDto> list = new ArrayList<>();

		for ( int i = 0; i < str.length; i++ ) {
			SeverityConfigurationDto temp = new SeverityConfigurationDto();
			temp.setSeverity( str[ i ] );
			temp.setProject( defaultProjectId );
			temp.setCompany( companyId );
			list.add( temp );
		}

		HttpEntity<List<SeverityConfigurationDto>> request = new HttpEntity<>( list, headers );
		ParameterizedTypeReference<List<SeverityConfigurationDto>> responseType = new ParameterizedTypeReference<List<SeverityConfigurationDto>>() {
		};

		try {
			ResponseEntity<List<SeverityConfigurationDto>> result = restTemplate.exchange( env.getProperty( "api.severities.add" ), HttpMethod.POST, request, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		return Collections.emptyList();
	}

	@Override
	public long deleteSeverity( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = restTemplate.exchange( env.getProperty( "api.severities.delete.by.id" ) + id, HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0l;

	}

	@Override
	public List<StatusConfigurationDto> saveStatus( StatusConfigurationDto dto, String token, Long companyId, Long defaultProjectId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		String priString = dto.getStatus();
		String[] str = priString.split( "," );
		List<StatusConfigurationDto> list = new ArrayList<>();
		for ( int i = 0; i < str.length; i++ ) {
			StatusConfigurationDto temp = new StatusConfigurationDto();
			temp.setStatus( str[ i ] );
			temp.setProject( defaultProjectId );
			temp.setCompany( companyId );
			list.add( temp );
		}
		HttpEntity<List<StatusConfigurationDto>> request = new HttpEntity<>( list, headers );
		ParameterizedTypeReference<List<StatusConfigurationDto>> responseType = new ParameterizedTypeReference<List<StatusConfigurationDto>>() {
		};

		try {
			ResponseEntity<List<StatusConfigurationDto>> result = restTemplate.exchange( env.getProperty( "api.status.add" ), HttpMethod.POST, request, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		return null;
	}

	@Override
	public long deleteStatus( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = restTemplate.exchange( env.getProperty( "api.status.delete.by.id" ) + id, HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0l;

	}
}
