package com.pluck.service;

import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectPagerDto;
import com.pluck.dto.project.ProjectRequestDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.project.ProjectUserRequestDto;
import com.pluck.dto.user.UserDropdownResponseDto;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@AllArgsConstructor
@Slf4j
public class ProjectServiceImpl implements ProjectService {

	private final Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public ProjectResponseDto addProject( ProjectRequestDto dto, LoginUserDto loginUserDto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.setLoginUserDto( loginUserDto );
		HttpEntity<ProjectRequestDto> entity = new HttpEntity<>( dto, headers );
		try {
			String url = env.getProperty( "api.project" );
			return restTemplate.exchange( url, HttpMethod.POST, entity, ProjectResponseDto.class )
					.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<UserDropdownResponseDto> getUsersDropdown( String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		restTemplate.getMessageConverters().add( new MappingJackson2HttpMessageConverter() );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );

		ParameterizedTypeReference<List<UserDropdownResponseDto>> responseType = new ParameterizedTypeReference<List<UserDropdownResponseDto>>() {
		};

		try {
			String url = env.getProperty( "api.user.DropDown" );
			ResponseEntity<List<UserDropdownResponseDto>> result = restTemplate.exchange( url,
					HttpMethod.GET, entity, responseType );

			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return Collections.emptyList();

	}

	@Override
	public ProjectPagerDto findAll( LoginUserDto loggingUser, String token, int pageNo ) throws URISyntaxException {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			String url = env.getProperty( "api.project.all" );
			ResponseEntity<ProjectPagerDto> result = restTemplate.exchange(
					url + pageNo + "&company_id=" + loggingUser.getCompanyId(),
					HttpMethod.GET, entity, ProjectPagerDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public ProjectResponseDto findById( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		final String baseUrl = env.getProperty( "api.project.by.id" ) + id;
		log.error( "calling URL " + baseUrl );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<ProjectResponseDto> result = restTemplate.exchange( baseUrl, HttpMethod.GET, entity,
					ProjectResponseDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public ProjectResponseDto updateProject( ProjectRequestDto projectRequestDto, LoginUserDto loginUserDto,
			String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		projectRequestDto.setLoginUserDto( loginUserDto );
		HttpEntity<ProjectRequestDto> entity = new HttpEntity<>( projectRequestDto, headers );
		try {
			return restTemplate.exchange( env.getProperty( "api.project" ), HttpMethod.PUT, entity, ProjectResponseDto.class )
					.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String removeUser( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		projectUserRequestDto.setLoginUserDto( loginUserDto );
		HttpEntity<ProjectUserRequestDto> entity = new HttpEntity<>( projectUserRequestDto, headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.project.remove.user" ), HttpMethod.PUT,
					entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String removeOwner( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		projectUserRequestDto.setLoginUserDto( loginUserDto );
		HttpEntity<ProjectUserRequestDto> entity = new HttpEntity<>( projectUserRequestDto, headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.project.remove.owner" ), HttpMethod.PUT,
					entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String addOwner( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		projectUserRequestDto.setLoginUserDto( loginUserDto );
		HttpEntity<ProjectUserRequestDto> entity = new HttpEntity<>( projectUserRequestDto, headers );
		try {
			return restTemplate.exchange( env.getProperty( "api.project.add.owner" ), HttpMethod.PUT, entity, String.class )
					.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	

	@Override
	public Set<UserResponseDTO> allUsersByProject( Long defaultProjectId, Long companyId, String token, int pageNo ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );

		ParameterizedTypeReference<Set<UserResponseDTO>> responseType = new ParameterizedTypeReference<Set<UserResponseDTO>>() {
		};

		try {
			String url = env.getProperty( "api.users.project" );
			ResponseEntity<Set<UserResponseDTO>> result = restTemplate.exchange( url + pageNo + "&defaultProjectId=" + defaultProjectId + "&companyId=" + companyId, HttpMethod.GET, entity, responseType );

			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}
	
	@Override
	public String addUser( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		projectUserRequestDto.setLoginUserDto( loginUserDto );
		HttpEntity<ProjectUserRequestDto> entity = new HttpEntity<>( projectUserRequestDto, headers );
		try {
			return restTemplate.exchange( env.getProperty( "api.project.add.user" ), HttpMethod.PUT, entity, String.class )
					.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<ProjectResponseDto> scrumMasterProject( Long id, long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );

		ParameterizedTypeReference<List<ProjectResponseDto>> responseType = new ParameterizedTypeReference<List<ProjectResponseDto>>() {
		};

		try {
			String url = env.getProperty( "api.scrum.project" ) + id + "/" +companyId;
			ResponseEntity<List<ProjectResponseDto>> result = restTemplate.exchange( url, HttpMethod.GET,
					entity, responseType );

			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public int countByCompanyIdAndName( Long companyId, String name, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Integer> responseType = new ParameterizedTypeReference<Integer>() {
		};

		try {
			String url = env.getProperty( "api.project.count" );
			ResponseEntity<Integer> result = restTemplate.exchange(
					url + companyId + "/" + name, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public List<ProjectResponseDto> topFiveProjectsByUser( String token, Long loggedInUserId, Long companyId ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<ProjectResponseDto>> responseType = new ParameterizedTypeReference<List<ProjectResponseDto>>() {
		};

		try {
			String url = env.getProperty( "api.login.user.project" );
			ResponseEntity<List<ProjectResponseDto>> result = restTemplate.exchange( url + loggedInUserId + "/" + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public ProjectPagerDto getAllProjectsByUser( String token, Long loggedInUserId, Long companyId, int pageNo ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<ProjectPagerDto> responseType = new ParameterizedTypeReference<ProjectPagerDto>() {
		};
		try {
			ResponseEntity<ProjectPagerDto> result = restTemplate.exchange( env.getProperty( "api.login.user.all.project" ) + loggedInUserId + "/" + companyId + "/" + pageNo, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public int countAllprojectByCompany( Long companyId, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Integer> responseType = new ParameterizedTypeReference<Integer>() {
		};
		try {
			ResponseEntity<Integer> result = restTemplate.exchange(
					env.getProperty( "api.company.project.count" ) + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public void reloadRoleConfiguration( Long project, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );

		try {
			restTemplate.exchange(
					env.getProperty( "api.change.role.configuration" ) + project, HttpMethod.GET, entity, String.class );
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

	}

	@Override
	public Map<String, Integer> findTaskCountForProject( Long companyId, Long project, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Map<String, Integer>> responseType = new ParameterizedTypeReference<Map<String, Integer>>() {
		};
		try {
			ResponseEntity<Map<String, Integer>> result = restTemplate.exchange( env.getProperty( "api.task.report.tasks.count1" ) + companyId + "/" + project, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

}
