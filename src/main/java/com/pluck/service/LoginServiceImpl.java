package com.pluck.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.ForgotPasswordRequestDto;
import com.pluck.dto.LoginFormDto;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.user.ChangePasswordDto;
import com.pluck.dto.user.SignUpRequestDto;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@AllArgsConstructor
@Slf4j
public class LoginServiceImpl implements LoginService {

	private final Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public String login( LoginFormDto dto, String ipAddress ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "clientip", ipAddress );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );

		HttpEntity<LoginFormDto> request = new HttpEntity<>( dto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.login" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public LoginUserDto loadLoggedInUser( String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			String url = env.getProperty( "api.login.details.load" );
			ResponseEntity<LoginUserDto> result = restTemplate.exchange( url, HttpMethod.GET, entity, LoginUserDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String signUp( SignUpRequestDto signUpDto ) {

		HttpHeaders headers = new HttpHeaders();
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<SignUpRequestDto> request = new HttpEntity<>( signUpDto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.user.signUp" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String changePassword( ChangePasswordDto changePassDto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<ChangePasswordDto> request = new HttpEntity<>( changePassDto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.user.changePassword" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public String forgotPassword( ForgotPasswordRequestDto requestDto ) {
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<ForgotPasswordRequestDto> request = new HttpEntity<>( requestDto, headers );
		try {
			ResponseEntity<String> result = restTemplate.postForEntity( env.getProperty( "api.forgot.password" ), request, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;
	}

	@Override
	public Integer getHigherRoleValue( String role ) {
		return getRoleValue( role );
	}

	@Override
	public String getHighestRole( List<String> roles ) {
		int value = 0;
		for ( String role : roles ) {
			int temp = getRoleValue( role );
			if ( temp > value )
				value = temp;
		}
		return getHighestRole( value );
	}

	private static int getRoleValue( String role ) {
		switch ( role ) {
		case "Super Admin":
			return 6;
		case "Company Admin":
			return 5;
		case "Project Manager":
			return 4;
		case "Project Lead":
			return 3;
		case "Scrum Master":
			return 2;
		case "Project User":
			return 1;
		default:
			break;
		}
		return 0;

	}

	private static String getHighestRole( int value ) {
		switch ( value ) {
		case 6:
			return "Super Admin";
		case 5:
			return "Company Admin";
		case 4:
			return "Project Manager";
		case 3:
			return "Project Lead";
		case 2:
			return "Scrum Master";
		case 1:
			return "Project User";
		default:
			break;
		}
		return null;
	}

	@Override
	public LoginUserDto getLoggedInUser( String token, Long project ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<LoginUserDto> result = restTemplate.exchange( env.getProperty( "api.login.details" ) + project, HttpMethod.GET, entity, LoginUserDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String getDefaultProjectToken( String userName, Long project, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<String> result = restTemplate.exchange( env.getProperty( "api.get.default.project.token" ) + userName + "/" + project, HttpMethod.GET, entity, String.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public boolean isHigherAuthority( String loginRole, String currentRole ) {
		int loginRoleValue = getRoleValue( loginRole );
		int currentRoleValue = getRoleValue( currentRole );
		return currentRoleValue < loginRoleValue;
	}

}
