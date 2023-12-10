package com.pluck.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.notification.NotificationResponceDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<NotificationResponceDto> getNotification( Long companyId, Long userId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<NotificationResponceDto>> responseType = new ParameterizedTypeReference<List<NotificationResponceDto>>() {
		};
		try {
			ResponseEntity<List<NotificationResponceDto>> result = restTemplate.exchange(
					env.getProperty( "api.notification.all" ) + companyId + " / " + userId, HttpMethod.GET, entity,
					responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public long delete( Long id, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = restTemplate.exchange( env.getProperty( "api.notification.delete.by.id" ) + id,
					HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0l;

	}

	@Override
	public long deleteAll( Long id, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = restTemplate.exchange( env.getProperty( "api.notification.delete.All" ) + id,
					HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0l;

	}

	@Override
	public NotificationResponceDto getNotificationById( Long id, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<NotificationResponceDto> result = restTemplate.exchange( env.getProperty( "api.notification.by.id" ) + id, HttpMethod.GET, entity,
					NotificationResponceDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}
}
