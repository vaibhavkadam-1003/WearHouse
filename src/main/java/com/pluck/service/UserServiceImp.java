package com.pluck.service;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
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

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserRequestDTO;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.user.Content;
import com.pluck.dto.user.InvalidTokenDto;
import com.pluck.dto.user.UserPagerDto;
import com.pluck.model.MultipartInputStreamFileResource;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@AllArgsConstructor
public class UserServiceImp implements UserService {

	private final Environment env;
	private final LoginService loginService;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public UserPagerDto findAll( String token, Long companyId, int pageNo ) throws URISyntaxException {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			String url = env.getProperty( "api.user.all" );
			ResponseEntity<UserPagerDto> result = restTemplate.exchange( url + "" + companyId + "&pageNo=" + pageNo, HttpMethod.GET, entity, UserPagerDto.class );
			UserPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public UserPagerDto findAllByStatus( String token, Long companyId, String status, int pageNo )
			throws URISyntaxException {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			String url = env.getProperty( "api.user.all.by.status" );
			ResponseEntity<UserPagerDto> result = restTemplate.exchange( url + "" + companyId + "&status=" + status + "&pageNo=" + pageNo, HttpMethod.GET, entity, UserPagerDto.class );
			UserPagerDto res = result.getBody();
			return res;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public UserResponseDTO findByid( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		final String baseUrl = env.getProperty( "api.user.by.id" ) + id;
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<UserResponseDTO> result = restTemplate.exchange( baseUrl, HttpMethod.GET, entity, UserResponseDTO.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String add( UserRequestDTO userRequestDTO, String token ) {

		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set( "Authorization", token );
			List<String> roles = userRequestDTO.getRole();
			String temp = "";
			for ( String r : roles ) {
				temp = temp + "," + r;
			}
			int indexOf = temp.indexOf( "," );
			String role = temp.substring( indexOf + 1, temp.length() );

			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "firstName", userRequestDTO.getFirstName() );
			requestMap.add( "lastName", userRequestDTO.getLastName() );
			requestMap.add( "username", userRequestDTO.getUsername() );
			requestMap.add( "company", userRequestDTO.getCompany() );
			requestMap.add( "status", userRequestDTO.getStatus() );
			requestMap.add( "role", role );
			requestMap.add( "projectId", userRequestDTO.getProjectId() );
			requestMap.add( "jobTitle", userRequestDTO.getJobTitle() );
			requestMap.add( "alternateEmailId", userRequestDTO.getAlternateEmailId() );
			requestMap.add( "contactNumber", userRequestDTO.getContactNumber() );
			requestMap.add( "countryCode", userRequestDTO.getCountryCode() );
			requestMap.add( "password", userRequestDTO.getPassword() );
			requestMap.add( "imagePath", userRequestDTO.getImagePath() );
			if ( userRequestDTO.getProfilePicFile() != null && !userRequestDTO.getProfilePicFile().isEmpty() ) {
				requestMap.add( "profilePicFile",
						new MultipartInputStreamFileResource( userRequestDTO.getProfilePicFile().getInputStream(),
								userRequestDTO.getProfilePicFile().getOriginalFilename() ) );
			} else {
				InputStream emptyInputStream = new ByteArrayInputStream( new byte[ 0 ] );
				String emptyFileName = "empty.txt";
				requestMap.add( "profilePicFile", new MultipartInputStreamFileResource( emptyInputStream, emptyFileName ) );
			}

			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.user" ),
					new HttpEntity<>( requestMap, headers ), String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String update( UserRequestDTO userRequestDTO, String token ) {

		try {
			HttpHeaders headers = new HttpHeaders();
			List<String> roles = userRequestDTO.getRole();
			String temp = "";
			for ( String r : roles ) {
				temp = temp + "," + r;
			}
			int indexOf = temp.indexOf( "," );
			String role = temp.substring( indexOf + 1, temp.length() );
			headers.set( "Authorization", token );
			MultiValueMap<String, Object> requestMap = new LinkedMultiValueMap<>();
			requestMap.add( "id", userRequestDTO.getId() );
			requestMap.add( "firstName", userRequestDTO.getFirstName() );
			requestMap.add( "lastName", userRequestDTO.getLastName() );
			requestMap.add( "username", userRequestDTO.getUsername() );
			requestMap.add( "company", userRequestDTO.getCompany() );
			requestMap.add( "projectId", userRequestDTO.getProjectId() );
			requestMap.add( "status", userRequestDTO.getStatus() );
			requestMap.add( "role", role );
			requestMap.add( "jobTitle", userRequestDTO.getJobTitle() );
			requestMap.add( "alternateEmailId", userRequestDTO.getAlternateEmailId() );
			requestMap.add( "contactNumber", userRequestDTO.getContactNumber() );
			requestMap.add( "countryCode", userRequestDTO.getCountryCode() );
			requestMap.add( "password", userRequestDTO.getContactNumber() );
			if ( userRequestDTO.getProfilePicFile() != null && !userRequestDTO.getProfilePicFile().isEmpty() ) {
				requestMap.add( "profilePicFile",
						new MultipartInputStreamFileResource( userRequestDTO.getProfilePicFile().getInputStream(),
								userRequestDTO.getProfilePicFile().getOriginalFilename() ) );
			} else {
				InputStream emptyInputStream = new ByteArrayInputStream( new byte[ 0 ] );
				String emptyFileName = "empty.txt";
				requestMap.add( "profilePicFile", new MultipartInputStreamFileResource( emptyInputStream, emptyFileName ) );
			}
			requestMap.add( "imagePath", userRequestDTO.getImagePath() );
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.user.update" ), HttpMethod.PUT, new HttpEntity<>( requestMap, headers ), String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public int countAllUsersByCompany( Long companyId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<Integer> responseType = new ParameterizedTypeReference<Integer>() {
		};
		try {
			ResponseEntity<Integer> result = restTemplate.exchange(
					env.getProperty( "api.company.user.count" ) + companyId, HttpMethod.GET, entity, responseType );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0;

	}

	@Override
	public long deleteProfileLogo( Long userId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<Long> result = restTemplate.exchange( env.getProperty( "api.user.profile.delete" ) + userId,
					HttpMethod.GET, entity, Long.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return 0l;

	}

	@Override
	public UserResponseDTO findByidAndProject( Long id, Long projectId, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		final String baseUrl = env.getProperty( "api.user.by.id.project" ) + id + "/" + projectId;
		log.error( "calling URL " + baseUrl );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<UserResponseDTO> result = restTemplate.exchange( baseUrl, HttpMethod.GET, entity, UserResponseDTO.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public Set<UserResponseDTO> setEditableFlag( Set<UserResponseDTO> list, Long defaultProjectId, String token, LoginUserDto loginUserDto, String currentRole ) {
		for ( UserResponseDTO dto : list ) {

			if ( Objects.equals( dto.getId(), loginUserDto.getId() ) ) {
				String highestRole = loginService.getHighestRole( dto.getRole() );
				dto.setHighestRole( highestRole );
				dto.setIsEditable( "true" );
			} else {
				String highestRole = loginService.getHighestRole( dto.getRole() );
				dto.setHighestRole( highestRole );
				boolean isHighAuth = loginService.isHigherAuthority( currentRole, highestRole );
				dto.setIsEditable( isHighAuth + "" );
			}
		}
		return list;
	}

	@Override
	public UserPagerDto setEditableFlagAllUser( UserPagerDto list, String token, LoginUserDto loggedInUser, String currentRole ) {
		if ( list != null ) {
			for ( Content dto : list.getContent() ) {
				if ( dto != null && loggedInUser != null ) {
					if ( Objects.equals( dto.getId(), loggedInUser.getId() ) ) {
						String highestRole = loginService.getHighestRole( dto.getRole() );
						dto.setHighestRole( highestRole );
						dto.setIsEditable( "true" );
					} else {
						String highestRole = loginService.getHighestRole( dto.getRole() );
						dto.setHighestRole( highestRole );
						boolean isHighAuth = loginService.isHigherAuthority( currentRole, highestRole );
						dto.setIsEditable( isHighAuth + "" );
					}
				}
			}
		}
		return list;
	}

	@Cacheable( value = "invalidTokens", key = "#username" )
	@Override
	public List<InvalidTokenDto> getInvalidTokens( String username, Long userId, String token ) {
		try {
			HttpHeaders httpHeaders = new HttpHeaders();
			httpHeaders.set( "Content-Type", MediaType.APPLICATION_JSON_VALUE );
			httpHeaders.set( "Accept", MediaType.APPLICATION_JSON_VALUE );
			httpHeaders.set( "userId", String.valueOf( userId ) );
			httpHeaders.set( "Authorization", "Bearer " + token );
			HttpEntity<String> entity = new HttpEntity<>( "body", httpHeaders );

			ResponseEntity<List<InvalidTokenDto>> result = restTemplate.exchange( env.getProperty( "api.user.invalid.token" ), HttpMethod.GET, entity, new ParameterizedTypeReference<>() {
			} );
			return result.getBody();
		} catch ( Exception e ) {

		}
		return new ArrayList<InvalidTokenDto>();
	}

	@CacheEvict( value = "invalidTokens", key = "#username" )
	@Override
	public String saveInvalidTokenDtos( InvalidTokenDto invalidTokenDto, String username, Long userId ) {
		try {
			HttpHeaders httpHeaders = new HttpHeaders();
			httpHeaders.set( "Content-Type", MediaType.APPLICATION_JSON_VALUE );
			httpHeaders.set( "Authorization", "Bearer " + invalidTokenDto.getToken() );
			httpHeaders.set( "Accept", MediaType.APPLICATION_JSON_VALUE );
			httpHeaders.set( "userId", String.valueOf( userId ) );
			HttpEntity<InvalidTokenDto> entity = new HttpEntity<>( invalidTokenDto, httpHeaders );

			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.user.invalid.token" ), HttpMethod.POST, entity, new ParameterizedTypeReference<>() {
			} );
			return result.getBody();
		} catch ( Exception e ) {

		}
		return "failed";
	}

}
