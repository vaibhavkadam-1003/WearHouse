package com.pluck.service;

import java.net.URISyntaxException;
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

import com.pluck.dto.inviteUser.Content;
import com.pluck.dto.inviteUser.InvitePagerDto;
import com.pluck.model.InvitatedUser;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InviteUserServiceImpl implements InviteUserService {

	@Autowired
	private Environment env;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public Map<String, List<String>> invite( InvitatedUser invitatedUser, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<InvitatedUser> request = new HttpEntity<>( invitatedUser, headers );
		ParameterizedTypeReference<Map<String, List<String>>> responseType = new ParameterizedTypeReference<Map<String, List<String>>>() {
		};
		try {
			Map<String, List<String>> result = restTemplate.exchange( env.getProperty( "api.inviteUser" ), HttpMethod.POST, request, responseType ).getBody();
			return result;
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public List<Content> findAll( String token ) throws URISyntaxException {

		HttpHeaders headers = new HttpHeaders();
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<InvitePagerDto> result = restTemplate.exchange( env.getProperty( "api.inviteUser.all" ), HttpMethod.GET, entity, InvitePagerDto.class );
			InvitePagerDto res = result.getBody();
			return res.getContent();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

}
