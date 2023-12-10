package com.pluck.service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.task.TaskAttachmentRequestDto;
import com.pluck.dto.task.TaskAttachmentResponseDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.dto.task.TaskPagerDto;
import com.pluck.model.MultipartInputStreamFileResource;
import com.pluck.utilites.StatusWrapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class TaskServiceImpl implements TaskService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<String> getPriorities( String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<String>> responseType = new ParameterizedTypeReference<List<String>>() {
		};
		try {
			ResponseEntity<List<String>> result = restTemplate.exchange( env.getProperty( "api.utilities.priority" ),
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<String> getSeverties( String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<String>> responseType = new ParameterizedTypeReference<List<String>>() {
		};
		try {
			ResponseEntity<List<String>> result = restTemplate.exchange( env.getProperty( "api.utilities.severity" ),
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<String> getTaskType( String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<String>> responseType = new ParameterizedTypeReference<List<String>>() {
		};
		try {
			ResponseEntity<List<String>> result = restTemplate.exchange( env.getProperty( "api.utilities.taskType" ),
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<String> getTaskStatus( String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<String>> responseType = new ParameterizedTypeReference<List<String>>() {
		};
		try {
			ResponseEntity<List<String>> result = restTemplate.exchange( env.getProperty( "api.utilities.taskStatus" ),
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String addTask( TaskDto dto, String token, Long companyId, Long defaultProjectId, LoginUserDto loggedInUser ) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "taskType", dto.getTaskType() );
			requestMap.add( "title", dto.getTitle() );
			requestMap.add( "description", dto.getDescription() );
			requestMap.add( "assignedTo", dto.getAssignedTo() );
			requestMap.add( "assigneName", dto.getAssigneName() );
			requestMap.add( "priority", dto.getPriority() );
			requestMap.add( "severity", dto.getSeverity() );
			if ( dto.getStartDate() != null )
				requestMap.add( "startDate", dto.getStartDate().toString() );
			if ( dto.getLastDate() != null )
				requestMap.add( "lastDate", dto.getLastDate().toString() );
			requestMap.add( "project", dto.getProject() );
			requestMap.add( "company", dto.getCompany() );
			requestMap.add( "status", dto.getStatus() );
			requestMap.add( "sprint", dto.getSprint() );
			requestMap.add( "loggedInUserId", loggedInUser.getId() );
			requestMap.add( "firstName", loggedInUser.getFirstName() );
			requestMap.add( "lastName", loggedInUser.getLastName() );
			requestMap.add( "story_point", dto.getStory_point() );
			requestMap.add( "addedBy", dto.getAddedBy() );
			requestMap.add( "originalEstimate", dto.getOriginalEstimate() );

			if ( !( dto.getFiles().get( 0 ).getOriginalFilename() == "" ) ) {

				for ( MultipartFile files : dto.getFiles() ) {
					requestMap.add( "files",
							new MultipartInputStreamFileResource( files.getInputStream(), files.getOriginalFilename() ) );
				}
			} else {
				InputStream emptyInputStream = new ByteArrayInputStream( new byte[ 0 ] );
				String emptyFileName = "empty.txt";
				requestMap.add( "files", new MultipartInputStreamFileResource( emptyInputStream, emptyFileName ) );
			}

			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.user.task.add" ),
					new HttpEntity<>( requestMap, headers ), String.class );

			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to add";
	}

	@Override
	public TaskPagerDto allUserTask( String token, Integer pageNo, int pageSize, Long companyId, Long projectId ) {

		pageNo = pageNo == null ? 10 : pageNo;

		int start = ( pageNo * pageNo ) - pageNo;

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
					env.getProperty( "api.user.task.all" ) + companyId + "/" + projectId + "?pageNo=" + start + "&pageSize=" + pageSize,
					HttpMethod.GET, entity, responseType );
			TaskPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto allTaskByActiveSprint( String token, int pageNo, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
				env.getProperty( "api.user.task.all.bysprint" ) + companyId + "/" + projectId + "?pageNo=" + pageNo,
				HttpMethod.GET, entity, responseType );
		TaskPagerDto res = result.getBody();
		return res;
	}

	@Override
	public TaskPagerDto allTaskByProject( String token, int pageNo, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
					env.getProperty( "api.user.task.all.byproject" ) + companyId + "/" + projectId + "?pageNo=" + pageNo,
					HttpMethod.GET, entity, responseType );
			TaskPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskDto findTaskById( String token, Long taskId, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<TaskDto> result = restTemplate.exchange(
					env.getProperty( "api.user.task.by.id" ) + taskId + "/" + companyId + "/" + projectId, HttpMethod.GET,
					entity, TaskDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskAttachmentResponseDto> findAttachmentById( String token, Long taskId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskAttachmentResponseDto>> responseType = new ParameterizedTypeReference<List<TaskAttachmentResponseDto>>() {
		};
		try {
			ResponseEntity<List<TaskAttachmentResponseDto>> result = restTemplate.exchange(
					env.getProperty( "api.user.task.attchment.by.id" ) + taskId, HttpMethod.GET, entity, responseType );
			List<TaskAttachmentResponseDto> res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String updateTask( TaskDto dto, String token, Long companyId, Long defaultProjectId ) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "id", dto.getId() );
			requestMap.add( "taskType", dto.getTaskType() );
			requestMap.add( "title", dto.getTitle() );
			requestMap.add( "description", dto.getDescription() );
			requestMap.add( "assignedTo", dto.getAssignedTo() );
			requestMap.add( "priority", dto.getPriority() );
			requestMap.add( "severity", dto.getSeverity() );
			if ( dto.getStartDate() != null )
				requestMap.add( "startDate", dto.getStartDate().toString() );
			if ( dto.getLastDate() != null )
				requestMap.add( "lastDate", dto.getLastDate().toString() );
			requestMap.add( "project", dto.getProject() );
			requestMap.add( "company", dto.getCompany() );
			requestMap.add( "status", dto.getStatus() );
			requestMap.add( "sprint", dto.getSprint() );
			requestMap.add( "story_point", dto.getStory_point() );
			requestMap.add( "addedBy", dto.getAddedBy() );
			requestMap.add( "updatedBy", dto.getUpdatedBy() );
			requestMap.add( "firstName", dto.getFirstName() );
			requestMap.add( "lastName", dto.getLastName() );
			requestMap.add( "originalEstimate", dto.getOriginalEstimate() );
			requestMap.add( "timeTracking", dto.getTimeTracking() );
			if ( dto.getFiles() != null ) {

				if ( !( dto.getFiles().get( 0 ).getOriginalFilename() == "" ) ) {

					for ( MultipartFile files : dto.getFiles() ) {
						requestMap.add( "files",
								new MultipartInputStreamFileResource( files.getInputStream(), files.getOriginalFilename() ) );
					}
				} else {
					InputStream emptyInputStream = new ByteArrayInputStream( new byte[ 0 ] );
					String emptyFileName = "empty.txt";
					requestMap.add( "files", new MultipartInputStreamFileResource( emptyInputStream, emptyFileName ) );
				}
			}
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.user.task.update" ), HttpMethod.PUT,
					new HttpEntity<>( requestMap, headers ), String.class );

			return result.getBody();

		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String updateTaskAttachmentsModal( TaskDto dto, String token ) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "id", dto.getId() );
			requestMap.add( "project", dto.getProject() );
			requestMap.add( "company", dto.getCompany() );
			requestMap.add( "updatedBy", dto.getUpdatedBy() );

			for ( MultipartFile files : dto.getFiles() ) {
				requestMap.add( "files",
						new MultipartInputStreamFileResource( files.getInputStream(), files.getOriginalFilename() ) );
			}
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.user.task.update.files" ), HttpMethod.PUT,
					new HttpEntity<>( requestMap, headers ), String.class );

			return result.getBody();

		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String updateTaskModal( TaskDto dto, String token, Long companyId, Long defaultProjectId ) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "id", dto.getId() );
			requestMap.add( "taskType", dto.getTaskType() );
			requestMap.add( "title", dto.getTitle() );
			requestMap.add( "description", dto.getDescription() );
			requestMap.add( "assignedTo", dto.getAssignedTo() );
			requestMap.add( "priority", dto.getPriority() );
			requestMap.add( "severity", dto.getSeverity() );
			if ( dto.getStartDate() != null )
				requestMap.add( "startDate", dto.getStartDate().toString() );
			if ( dto.getLastDate() != null )
				requestMap.add( "lastDate", dto.getLastDate().toString() );
			requestMap.add( "project", dto.getProject() );
			requestMap.add( "company", dto.getCompany() );
			requestMap.add( "status", dto.getStatus() );
			requestMap.add( "sprint", dto.getSprint() );
			requestMap.add( "story_point", dto.getStory_point() );
			requestMap.add( "addedBy", dto.getAddedBy() );
			requestMap.add( "updatedBy", dto.getUpdatedBy() );
			requestMap.add( "originalEstimate", dto.getOriginalEstimate() );
			requestMap.add( "timeTracking", dto.getTimeTracking() );
			requestMap.add( "firstName", dto.getFirstName() );
			requestMap.add( "lastName", dto.getLastName() );

			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.user.task.update.modal" ), HttpMethod.PUT,
					new HttpEntity<>( requestMap, headers ), String.class );

			return result.getBody();

		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public TaskDto updateTask1( TaskDto dto, String token, Long companyId, Long defaultProjectId ) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "id", dto.getId() );
			requestMap.add( "status", dto.getStatus() );
			requestMap.add( "updatedBy", dto.getUpdatedBy() );

			ResponseEntity<TaskDto> result = restTemplate.exchange( env.getProperty( "api.user.task.update1" ), HttpMethod.PUT,
					new HttpEntity<>( requestMap, headers ), TaskDto.class );

			return result.getBody();

		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> getAllIncompleteTasks( String token, Long companyId, Long projectId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			String url = env.getProperty( "api.user.task.incomplete.all" ) + companyId + "/" + projectId;
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( url, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> getAllIncompleteTasksToStartSprint( String token, Long companyId, Long projectId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			String url = env.getProperty( "api.user.start.sprint.task.incomplete.all" ) + companyId + "/" + projectId;
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( url, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto findTaskByStatus( StatusWrapper status, String token, Long companyId, Long defaultProjectId,
			int pageNo ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		status.setDefaultProjectId( defaultProjectId );
		status.setCompanyId( companyId );
		String url = env.getProperty( "api.user.task.all.by.status" ) + pageNo;
		HttpEntity<StatusWrapper> entity = new HttpEntity<>( status, headers );
		try {
			return restTemplate.exchange( url, HttpMethod.POST, entity, TaskPagerDto.class ).getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public int deleteTask( String token, Long id, Long userId, Long companyId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( env.getProperty( "api.user.task.delete.by.id" ) + id + "/" + userId + "/" + companyId,
					HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public int getTaskCount( String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		String url = env.getProperty( "api.task.count" ) + companyId + "/" + defaultProjectId;
		try {
			ResponseEntity<Integer> result = restTemplate.exchange( url, HttpMethod.GET, entity, Integer.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public List<TaskDto> getTop5TasksByUser( String token, Long loggedInUserId, Long defaultProjectId, Long companyId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		String url = env.getProperty( "api.task.top.five.by.user" ) + loggedInUserId + "/" + defaultProjectId + "/" + companyId;
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( url, HttpMethod.GET, entity, responseType );
			List<TaskDto> res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto getAllTasksByUser( String token, Long loggedInUserId, Long defaultProjectId, Long companyId, int pageNo ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange( env.getProperty( "api.user.all.task" ) + loggedInUserId + "/" + defaultProjectId + "/" + companyId + "/" + pageNo, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public int countAllTasksByCompany( Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Integer> responseType = new ParameterizedTypeReference<Integer>() {
		};
		try {
			ResponseEntity<Integer> result = restTemplate.exchange(
					env.getProperty( "api.company.task.count" ) + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public List<TaskDto> findTop5TasksByProject( Long companyId, Long projectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		String url = env.getProperty( "api.task.top.five.by.project" ) + companyId + "/" + projectId;
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( url, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto getAllTaskByUser( String token, int pageNo, Long companyId, Long projectId, Long selectedUserId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
					env.getProperty( "api.user.all.task1" ) + companyId + "/" + projectId + "/" + selectedUserId + "?pageNo=" + pageNo,
					HttpMethod.GET, entity, responseType );
			TaskPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto getAllCompletedTask( String token, int pageNo, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
					env.getProperty( "api.user.completed.task.all" ) + companyId + "/" + projectId + "?pageNo=" + pageNo,
					HttpMethod.GET, entity, responseType );
			TaskPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto getAllInCompleteTask( String token, int pageNo, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
					env.getProperty( "api.user.inCompleted.task.all" ) + companyId + "/" + projectId + "?pageNo=" + pageNo,
					HttpMethod.GET, entity, responseType );
			TaskPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> TaskFilter( Long project, String status, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			String url = env.getProperty( "api.task.by.project.status" ) + project + "/" + status;
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( url, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String addTaskAttachment( TaskAttachmentRequestDto taskAttachmentRequestDto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();

		requestMap.add( "taskId", taskAttachmentRequestDto.getTaskId() );
		requestMap.add( "companyId", taskAttachmentRequestDto.getCompanyId() );
		requestMap.add( "userId", taskAttachmentRequestDto.getUserId() );
		if ( taskAttachmentRequestDto.getFiles() != null ) {
			for ( MultipartFile taskFiles : taskAttachmentRequestDto.getFiles() ) {
				try {
					requestMap.add( "files",
							new MultipartInputStreamFileResource( taskFiles.getInputStream(), taskFiles.getOriginalFilename() ) );
				} catch ( IOException e ) {
					log.error( e.getMessage(), e );
				}
			}
		}
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.task.attachment.add" ), new HttpEntity<>( requestMap, headers ), String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<StatusConfigurationDto> statusDropdownGenerator( String token, String currentStatus, Long defaultProjectId, Long companyId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<StatusConfigurationDto>> responseType = new ParameterizedTypeReference<List<StatusConfigurationDto>>() {
		};

		try {

			ResponseEntity<List<StatusConfigurationDto>> result = restTemplate.exchange( env.getProperty( "api.task.status.available" ) + defaultProjectId + "?currentStatus=" + currentStatus + "&companyId=" + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String getStatusById( String token, Long taskId, Long companyId, Long defaultProjectId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<String> responseType = new ParameterizedTypeReference<String>() {
		};
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.task.status" ) + taskId + "/" + "?companyId=" + companyId + "&defaultProjectId=" + defaultProjectId,
					HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskDto> findAllBacklogTasks( String token, Long companyId, Long projectId ) {

		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			String url = env.getProperty( "api.user.task.backlog.all" ) + companyId + "/" + projectId;
			ResponseEntity<List<TaskDto>> result = template.exchange( url, HttpMethod.GET, entity, responseType );
			List<TaskDto> res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String updateTaskStatus( Long taskId, String status ) {
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.task.update.status" ) + taskId + "/" + status, HttpMethod.GET, entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public TaskPagerDto allTasksBySearchQuery( String token, Integer pageNo, int pageSize, String searchQuery, Long companyId, Long projectId ) {

		pageNo = pageNo == null ? 10 : pageNo;

		int start = ( pageNo * pageNo ) - pageNo;

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<TaskPagerDto> responseType = new ParameterizedTypeReference<TaskPagerDto>() {
		};
		try {
			ResponseEntity<TaskPagerDto> result = restTemplate.exchange(
					env.getProperty( "api.user.task.search.paginated" ) + companyId + "/" + projectId +
							"?pageNo=" + start + "&pageSize=" + pageSize + "&searchQuery=" + searchQuery,
					HttpMethod.GET,
					entity,
					responseType );
			TaskPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}
}
