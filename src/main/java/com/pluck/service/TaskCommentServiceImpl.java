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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.pluck.dto.task.CommentAttachmentResponseDto;
import com.pluck.dto.task.TaskCommentDto;
import com.pluck.dto.task.TaskCommentResponseDto;
import com.pluck.model.MultipartInputStreamFileResource;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@AllArgsConstructor
public class TaskCommentServiceImpl implements TaskCommentService {

	private final Environment env;

	private final RestTemplate restTemplate;

	@Override
	public TaskCommentResponseDto addTaskComment( TaskCommentDto dto, String token ) {
		try {

			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "comment", dto.getComment() );
			requestMap.add( "taskId", dto.getTaskId() );
			requestMap.add( "companyId", dto.getCompanyId() );
			requestMap.add( "addedBy", dto.getAddedBy() );

			requestMap.add( "dateTimeString", dto.getDateTimeString() );
			if ( dto.getCommentFiles() != null ) {
				for ( MultipartFile commentFiles : dto.getCommentFiles() ) {
					requestMap.add( "commentFiles",
							new MultipartInputStreamFileResource( commentFiles.getInputStream(), commentFiles.getOriginalFilename() ) );
				}
			}
			TaskCommentResponseDto responseDto = null;
			try {
				ResponseEntity<TaskCommentResponseDto> result = restTemplate.postForEntity( env.getProperty( "api.task.comment.add" ), new HttpEntity<>( requestMap, headers ), TaskCommentResponseDto.class );
				responseDto = result.getBody();
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
			}

			if ( responseDto != null ) {

				LocalDateTime addedOn = responseDto.getAddedOn();
				String timeToString = addedOn.toString();
				String timeAgo = timeSince( timeToString );

				responseDto.setThisTimeAgo( timeAgo );
			}

			return responseDto;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskCommentResponseDto> getAllTaskComment( Long taskId, Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskCommentResponseDto>> responseType = new ParameterizedTypeReference<List<TaskCommentResponseDto>>() {
		};
		List<TaskCommentResponseDto> response = null;
		try {
			ResponseEntity<List<TaskCommentResponseDto>> taskComments = restTemplate.exchange( env.getProperty( "api.task.comment.all" ) + taskId + "/" + companyId, HttpMethod.GET, entity, responseType );
			response = taskComments.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		for ( TaskCommentResponseDto comment : response ) {

			LocalDateTime addedOn = comment.getAddedOn();
			String timeToString = addedOn.toString();
			String timeAgo = timeSince( timeToString );

			comment.setThisTimeAgo( timeAgo );

		}
		return response;
	}

	@Override
	public String deleteTaskComment( Long commentId, String token, Long companyId, Long userId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> request = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.task.comment.delete" ) + commentId + "/" + companyId + "/" + userId, HttpMethod.DELETE, request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to delete comment";

	}

	@Override
	public TaskCommentResponseDto updateTaskComment( TaskCommentDto dto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		try {
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "id", dto.getId() );
			requestMap.add( "comment", dto.getComment() );
			requestMap.add( "taskId", dto.getTaskId() );
			requestMap.add( "companyId", dto.getCompanyId() );
			requestMap.add( "addedBy", dto.getAddedBy() );
			requestMap.add( "updatedBy", dto.getUpdatedBy() );
			requestMap.add( "dateTimeString", dto.getDateTimeString() );
			if ( dto.getCommentFiles() != null ) {
				for ( MultipartFile commentFiles : dto.getCommentFiles() ) {
					requestMap.add( "commentFiles",
							new MultipartInputStreamFileResource( commentFiles.getInputStream(), commentFiles.getOriginalFilename() ) );
				}
			}
			TaskCommentResponseDto responseDto = null;
			try {
				ResponseEntity<TaskCommentResponseDto> result = restTemplate.exchange( env.getProperty( "api.task.comment.update" ), HttpMethod.PUT, new HttpEntity<>( requestMap, headers ), TaskCommentResponseDto.class );
				responseDto = result.getBody();
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
			}

			if ( responseDto != null ) {

				LocalDateTime addedOn = responseDto.getAddedOn();
				String timeToString = addedOn.toString();
				String timeAgo = timeSince( timeToString );

				responseDto.setThisTimeAgo( timeAgo );
			}

			return responseDto;

		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
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

	@Override
	public List<CommentAttachmentResponseDto> findAttachmentById( String token, Long commentId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<CommentAttachmentResponseDto>> responseType = new ParameterizedTypeReference<List<CommentAttachmentResponseDto>>() {
		};
		try {
			ResponseEntity<List<CommentAttachmentResponseDto>> result = restTemplate.exchange(
					env.getProperty( "api.task.comment.attachment" ) + "/" + commentId, HttpMethod.GET, entity, responseType );
			List<CommentAttachmentResponseDto> res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public int deleteCommentFile( String token, Long id ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<String>( "body", headers );
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( env.getProperty( "api.task.comment.attachment.delete" ) + "/" + id, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}
}
