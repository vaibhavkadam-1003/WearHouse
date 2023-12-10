package com.pluck;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@EnableCaching
@PropertySource( "classpath:api.properties" )
public class UIStarter {
	public static void main( String[] args ) {
		SpringApplication.run( UIStarter.class, args );
	}
}
