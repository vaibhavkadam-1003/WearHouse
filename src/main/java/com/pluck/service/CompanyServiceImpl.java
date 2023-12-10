package com.pluck.service;

import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.List;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.pluck.constants.Constants;
import com.pluck.dto.company.CompanyAdminShortDto;
import com.pluck.dto.company.CompanyDetailsResponseDto;
import com.pluck.dto.company.CompanyPageDto;
import com.pluck.dto.company.CompanyRequestDto;
import com.pluck.dto.company.CompanyResponseDTO;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@AllArgsConstructor
public class CompanyServiceImpl implements CompanyService {

	private final Environment env;

	private final RestTemplate restTemplate;

	@Override
	public String add( CompanyRequestDto dto, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		dto.getCompany().setMaxUsers( Integer.parseInt( dto.getCompany().getSubscriptionPlan() ) );
		HttpEntity<CompanyRequestDto> request = new HttpEntity<>( dto, headers );
		String url = env.getProperty( "api.company" );
		if ( url != null ) {
			try {
				ResponseEntity<String> result = restTemplate.postForEntity( url, request, String.class );
				return result.getBody();
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
			}
		}
		return null;
	}

	@Override
	public CompanyPageDto findAll( String token, int pageNo ) throws URISyntaxException {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<CompanyPageDto> result = restTemplate.exchange( env.getProperty( "api.company.all" ) + pageNo, HttpMethod.GET,
					entity, CompanyPageDto.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public CompanyResponseDTO findByid( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		final String baseUrl = env.getProperty( "api.company.by.id" ) + id;
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		try {
			ResponseEntity<CompanyResponseDTO> result = restTemplate.exchange( baseUrl, HttpMethod.GET, entity,
					CompanyResponseDTO.class );
			return result.getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

	@Override
	public String update( CompanyRequestDto companyRequestDto, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		HttpEntity<CompanyRequestDto> entity = new HttpEntity<>( companyRequestDto, headers );
		String url = env.getProperty( "api.company" );

		if ( url != null ) {
			try {
				ResponseEntity<String> result = restTemplate.exchange( url, HttpMethod.PUT, entity, String.class );
				return result.getBody();
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
			}
		}
		return null;

	}

	@Override
	public CompanyDetailsResponseDto getCompanyDetails( Long id, String token ) {

		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		CompanyResponseDTO company = findByid( id, token );
		List<CompanyAdminShortDto> admins = findAdminByCompanyId( id, token );
		CompanyDetailsResponseDto dto = new CompanyDetailsResponseDto();
		dto.setCompany( company );
		dto.setAdmins( admins );
		return dto;
	}

	private List<CompanyAdminShortDto> findAdminByCompanyId( Long id, String token ) {
		HttpHeaders headers = new HttpHeaders();
		headers.set( Constants.AUTHORIZATION, token );
		final String baseUrl = env.getProperty( "api.company.admin.by.id" ) + id;
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );
		ParameterizedTypeReference<List<CompanyAdminShortDto>> responseType = new ParameterizedTypeReference<List<CompanyAdminShortDto>>() {
		};
		try {
			return restTemplate.exchange( baseUrl, HttpMethod.GET, entity,
					responseType ).getBody();
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		return null;

	}

}
