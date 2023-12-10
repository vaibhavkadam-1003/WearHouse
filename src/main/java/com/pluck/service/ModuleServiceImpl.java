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

import com.pluck.dto.task.ModuleDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ModuleServiceImpl implements ModuleService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public ModuleDto add( ModuleDto dto, Long projectId, Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.setProject( projectId );
		dto.setCompany( companyId );
		HttpEntity<ModuleDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<ModuleDto> result = restTemplate.postForEntity( env.getProperty( "api.module.add" ), request, ModuleDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<ModuleDto> findAll( Long projectId, Long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ModuleDto>> responseType = new ParameterizedTypeReference<List<ModuleDto>>() {
		};
		try {
			ResponseEntity<List<ModuleDto>> result = restTemplate.exchange( env.getProperty( "api.module.all" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String update( ModuleDto dto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<ModuleDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange(
					env.getProperty( "api.module.update" ), HttpMethod.PUT, request, String.class );

			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		return "Unable to update module";
	}

	@Override
	public ModuleDto findById( Integer id, String token ) {
		try {
			String apiUrl = env.getProperty( "api.module.getById" ) + "/" + id;

			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );

			HttpEntity<String> request = new HttpEntity<>( headers );

			ResponseEntity<ModuleDto> response = restTemplate.exchange(
					apiUrl, HttpMethod.GET, request, ModuleDto.class );

			return response.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
			return null;
		}
	}

	@Override
	public int deleteById( Integer id, String token ) {
		try {

			String apiUrl = env.getProperty( "api.module.delete" ) + "/" + id;
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );

			HttpEntity<String> request = new HttpEntity<>( headers );

			ResponseEntity<Integer> response = restTemplate.exchange(
					apiUrl, HttpMethod.DELETE, request, Integer.class );

			return response.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;
	}

}
