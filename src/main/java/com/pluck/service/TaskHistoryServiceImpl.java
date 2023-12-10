package com.pluck.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.task.TaskHistoryResponseDto;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@AllArgsConstructor
public class TaskHistoryServiceImpl implements TaskHistoryService {

	private final Environment env;

	private final RestTemplate restTemplate;

	@Override
	public List<TaskHistoryResponseDto> getTaskHistory( Long taskId, String token ) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			HttpEntity<String> entity = new HttpEntity<>( "body", headers );
			ParameterizedTypeReference<List<TaskHistoryResponseDto>> responseType = new ParameterizedTypeReference<List<TaskHistoryResponseDto>>() {
			};
			ResponseEntity<List<TaskHistoryResponseDto>> result = restTemplate.exchange( env.getProperty( "api.task.history" ) + taskId, HttpMethod.GET, entity, responseType );
			List<TaskHistoryResponseDto> responseDto = result.getBody();

			for ( TaskHistoryResponseDto taskHistory : responseDto ) {
				String timeToString = taskHistory.getAddedOn().toString();
				String timeAgo = timeSince( timeToString );
				taskHistory.setThisTimeAgo( timeAgo );
			}

			return responseDto;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
			e.printStackTrace();
		}
		return null;
	}

	public static String timeSince( String dateString ) {
		LocalDateTime date = LocalDateTime.parse( dateString );
		LocalDateTime now = LocalDateTime.now();

		Duration duration = Duration.between( date, now );
		long seconds = duration.getSeconds();

		double interval = ( double ) seconds / 31536000;
		if ( interval > 1 ) {
			return ( int ) interval + " years ago";
		}

		interval = ( double ) seconds / 2592000;
		if ( interval > 1 ) {
			return ( int ) interval + " months ago";
		}

		interval = ( double ) seconds / 86400;
		if ( interval > 1 ) {
			return ( int ) interval + " days ago";
		}

		interval = ( double ) seconds / 3600;
		if ( interval > 1 ) {
			return ( int ) interval + " hours ago";
		}

		interval = ( double ) seconds / 60;
		if ( interval > 1 ) {
			return ( int ) interval + " minutes ago";
		}

		return seconds + " seconds ago";
	}

}
