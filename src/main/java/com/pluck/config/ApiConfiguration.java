package com.pluck.config;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

@Configuration
public class ApiConfiguration {

	@Bean
	@Scope( value = ConfigurableBeanFactory.SCOPE_PROTOTYPE )
	public HttpHeaders httpHeaders() {
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.set( "Content-Type", MediaType.APPLICATION_JSON_VALUE );
		httpHeaders.set( "Accept", MediaType.APPLICATION_JSON_VALUE );
		return httpHeaders;
	}

	@Bean
	RestTemplate restTemplate() {
		return new RestTemplate();
	}
}
