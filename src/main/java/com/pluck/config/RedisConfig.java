package com.pluck.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {

	@Value( "${spring.redis.host}" )
	private String redisHost;

	@Value( "${spring.redis.port}" )
	private int redisPort;

	@Value( "${spring.redis.password}" )
	private String redisPassword;

	@Bean
	JedisConnectionFactory jedisConnectionFactory() {
		RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration( redisHost, redisPort );
		redisStandaloneConfiguration.setPassword( RedisPassword.of( redisPassword ) );
		return new JedisConnectionFactory( redisStandaloneConfiguration );
	}

	@Bean
	RedisTemplate<Object, Object> sessionRedisTemplate(
			RedisConnectionFactory connectionFactory ) {
		RedisTemplate<Object, Object> template = new RedisTemplate<Object, Object>();
		template.setKeySerializer( new StringRedisSerializer() );
		template.setHashKeySerializer( new StringRedisSerializer() );

		template.setDefaultSerializer( new GenericJackson2JsonRedisSerializer() );

		template.setConnectionFactory( connectionFactory );
		return template;
	}
}
