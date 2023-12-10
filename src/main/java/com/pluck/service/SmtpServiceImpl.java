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

import com.pluck.dto.smtp.SmtpDto;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@AllArgsConstructor
public class SmtpServiceImpl implements SmtpService {

	private final Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public String save( SmtpDto smtpDto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<SmtpDto> request = new HttpEntity<>( smtpDto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.smtp" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<SmtpDto> findAllSmtp( String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> request = new HttpEntity<>( "body", headers );

		try {
			ResponseEntity<List<SmtpDto>> result = restTemplate.exchange( env.getProperty( "api.smtp" ), HttpMethod.GET, request,
					new ParameterizedTypeReference<List<SmtpDto>>() {
					} );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public SmtpDto findSmtp( long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		final String baseUrl = env.getProperty( "api.smtp.by.id" ) + id;
		HttpEntity<String> request = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<SmtpDto> result = restTemplate.exchange( baseUrl, HttpMethod.GET, request, SmtpDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}
}