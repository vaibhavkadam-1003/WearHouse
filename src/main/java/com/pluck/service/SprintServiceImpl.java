package com.pluck.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

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

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.sprint.ActiveSprintsDto;
import com.pluck.dto.sprint.CloseSprintDto;
import com.pluck.dto.sprint.SprintHistoryResponseDto;
import com.pluck.dto.sprint.SprintHistoryTaskDto;
import com.pluck.dto.sprint.SprintTaskHistory;
import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.sprint.StartSprintRequestDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SprintServiceImpl implements SprintService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public String addSprint( SprintDto dto, String token, LoginUserDto loggedInUser, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.setCompany( loggedInUser.getCompanyId() );
		dto.setProject( defaultProjectId );
		dto.setAddedBy( loggedInUser.getId() );
		HttpEntity<SprintDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.sprint.add" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to add sprint";
	}

	@Override
	public List<SprintDto> findAll( String token, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintDto>> responseType = new ParameterizedTypeReference<List<SprintDto>>() {
		};
		try {
			ResponseEntity<List<SprintDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.all" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, List<TaskDto>> findTasksBySprint( String token, Long companyId, Long projectId, int sprintId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, List<TaskDto>>> responseType = new ParameterizedTypeReference<Map<String, List<TaskDto>>>() {
		};
		try {
			ResponseEntity<Map<String, List<TaskDto>>> result = restTemplate.exchange( env.getProperty( "api.sprint.by.id" ) + companyId + "/" + projectId + "/" + sprintId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SprintDto> findAvailableSprints( String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintDto>> responseType = new ParameterizedTypeReference<List<SprintDto>>() {
		};
		try {
			ResponseEntity<List<SprintDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.available" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String startSprint( String token, StartSprintRequestDto dto ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<StartSprintRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.sprint.start" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to start sprint";
	}

	@Override
	public SprintDto findCurrentSprint( String token, Long companyId, Long projectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<SprintDto> result = restTemplate.exchange( env.getProperty( "api.sprint.current" ) + companyId + "/" + projectId, HttpMethod.GET, entity, SprintDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, Integer> findSprintInfo( String token, Long companyId, Long defaultProjectId, Integer id ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};
		try {
			ResponseEntity<Map<String, Integer>> result = restTemplate.exchange( env.getProperty( "api.sprint.current.info" ) + companyId + "/" + defaultProjectId + "/" + id, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String closeSprint( String token, Long companyId, Long defaultProjectId, Integer id, CloseSprintDto dto ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.setCompanyId( companyId );
		dto.setProjectId( defaultProjectId );
		dto.setSprintId( id );
		HttpEntity<CloseSprintDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.sprint.current.close" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public TaskDto addTaskToSprint( String token, Long id, Integer sprintId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<TaskDto> result = restTemplate.exchange( env.getProperty( "api.sprint.current.add.task" ) + id + "/" + sprintId, HttpMethod.GET, entity, TaskDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SprintDto> findPreviousSprints( String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintDto>> responseType = new ParameterizedTypeReference<List<SprintDto>>() {
		};
		try {
			ResponseEntity<List<SprintDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.previous" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return new ArrayList<SprintDto>();

	}

	@Override
	public List<SprintDto> findActiveSprints( String token, Long companyId, Long defaultProjectId ) {
		RestTemplate template = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintDto>> responseType = new ParameterizedTypeReference<List<SprintDto>>() {
		};
		try {
			ResponseEntity<List<SprintDto>> result = template.exchange( env.getProperty( "api.sprint.active" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return new ArrayList<SprintDto>();
	}

	@Override
	public List<SprintHistoryResponseDto> findHistoryById( String token, Long defaultProjectId, Integer id ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintHistoryResponseDto>> responseType = new ParameterizedTypeReference<List<SprintHistoryResponseDto>>() {
		};
		try {
			ResponseEntity<List<SprintHistoryResponseDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.previous.history" ) + defaultProjectId + "/" + id, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SprintUserChartDetailsDto> findCurrentSprintUserChartDetails( Long companyId, Long defaultProjectId, Integer currentSprint, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintUserChartDetailsDto>> responseType = new ParameterizedTypeReference<List<SprintUserChartDetailsDto>>() {
		};
		try {
			ResponseEntity<List<SprintUserChartDetailsDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.current.user.chart.details" ) + companyId + "/" + defaultProjectId + "/" + currentSprint, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SprintUserChartDetailsDto> findSprintHistoryUserChartDetails( Long companyId, Long defaultProjectId, Integer currentSprint, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintUserChartDetailsDto>> responseType = new ParameterizedTypeReference<List<SprintUserChartDetailsDto>>() {
		};
		try {
			ResponseEntity<List<SprintUserChartDetailsDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.history.user.chart.details" ) + companyId + "/" + defaultProjectId + "/" + currentSprint, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<ScrumTeamResponseDto> findScrumTeamForSprint( Long companyId, Integer currentSprint, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ScrumTeamResponseDto>> responseType = new ParameterizedTypeReference<List<ScrumTeamResponseDto>>() {
		};
		try {
			ResponseEntity<List<ScrumTeamResponseDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.current.scrum.teams" ) + companyId + "/" + currentSprint, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> currentSprintAllTasks( Long companyId, Long defaultProjectId, Integer currentSprint, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.current.tasks" ) + companyId + "/" + defaultProjectId + "/" + currentSprint, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String addScrumToSprint( String token, StartSprintRequestDto dto ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<StartSprintRequestDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.sprint.add.scrum" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return "Unable to start sprint";
	}

	@Override
	public List<SprintHistoryTaskDto> sprintAllTasksHistory( Long companyId, Long defaultProjectId, Integer sprintId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintHistoryTaskDto>> responseType = new ParameterizedTypeReference<List<SprintHistoryTaskDto>>() {
		};
		try {
			ResponseEntity<List<SprintHistoryTaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.previous.tasks" ) + defaultProjectId + "/" + sprintId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Map<String, List<TaskDto>> findTasksByProjects( String token, Long companyId, Long defaultProjectId ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, List<TaskDto>>> responseType = new ParameterizedTypeReference<Map<String, List<TaskDto>>>() {
		};

		try {
			ResponseEntity<Map<String, List<TaskDto>>> result = restTemplate.exchange( env.getProperty( "api.project.by.task.id" ) + companyId + "/" + defaultProjectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SprintUserChartDetailsDto> findCurrentProjectUserChartDetails( Long companyId, Long defaultProjectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintUserChartDetailsDto>> responseType = new ParameterizedTypeReference<List<SprintUserChartDetailsDto>>() {
		};
		try {
			ResponseEntity<List<SprintUserChartDetailsDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.current.project.chart.details" ) + companyId + "/" + defaultProjectId + "/", HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String findName( int sprintId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.sprint.previous.history.sprint.name" ) + sprintId, HttpMethod.GET, entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<TaskDto> findSprintTasks( Integer sprintId, String status, String token ) {

		SprintTaskHistory dto = new SprintTaskHistory();
		dto.setSprintId( sprintId );
		dto.setStatus( status );
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<SprintTaskHistory> request = new HttpEntity<>( dto, headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.tasks.history" ), HttpMethod.POST, request, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskDto> currentSprintTaskFilter( Integer currentSprint, String status, String token ) {

		SprintTaskHistory dto = new SprintTaskHistory();
		dto.setSprintId( currentSprint );
		dto.setStatus( status );
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<SprintTaskHistory> request = new HttpEntity<>( dto, headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.tasks.filter" ), HttpMethod.POST, request, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<TaskDto> sprintHistoryTaskFilter( Integer sprintId, String status, String token ) {
		SprintTaskHistory dto = new SprintTaskHistory();
		dto.setSprintId( sprintId );
		dto.setStatus( status );
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<SprintTaskHistory> request = new HttpEntity<>( dto, headers );
		ParameterizedTypeReference<List<TaskDto>> responseType = new ParameterizedTypeReference<List<TaskDto>>() {
		};
		try {
			ResponseEntity<List<TaskDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.history.tasks.filter" ), HttpMethod.POST, request, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public List<ActiveSprintsDto> findActiveSprintsForUser( Long companyId, Long userId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ActiveSprintsDto>> responseType = new ParameterizedTypeReference<List<ActiveSprintsDto>>() {
		};
		try {
			ResponseEntity<List<ActiveSprintsDto>> result = restTemplate.exchange( env.getProperty( "api.sprint.active.sprint.by.user" ) + companyId + "/" + userId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public SprintDto findById( Integer sprintId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<SprintDto> result = restTemplate.exchange( env.getProperty( "api.sprint.by.id" ) + sprintId, HttpMethod.GET, entity, SprintDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Long countByAndScrumIdAndStatus( Long scrumTeams, String token ) {
		RestTemplate template = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = template.exchange( env.getProperty( "api.sprint.by.scrumId" ) + scrumTeams, HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public SprintDto findCurrentActiveSprint( String token, Long companyId, Long projectId, Integer id ) {
		RestTemplate template = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );

		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<SprintDto> result = template.exchange( env.getProperty( "api.current.active.sprint" ) + companyId + "/" + projectId + "/" + id, HttpMethod.GET, entity, SprintDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<SprintDto> findBacklogActiveSprints( String token, Long companyId, Long projectId ) {
		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<SprintDto>> responseType = new ParameterizedTypeReference<List<SprintDto>>() {
		};
		try {
			ResponseEntity<List<SprintDto>> result = template.exchange( env.getProperty( "api.sprint.active.backlog" ) + companyId + "/" + projectId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return new ArrayList<SprintDto>();
	}
}
