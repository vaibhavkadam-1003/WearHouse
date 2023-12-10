package com.pluck.security;

import java.util.Date;
import java.util.List;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.HttpServletRequest;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JwtConfig {

	@Value( "${security.jwt.uri}" )
	private String uri;

	@Value( "${security.jwt.header}" )
	private String header;

	@Value( "${security.jwt.prefix}" )
	private String prefix;

	@Value( "${security.jwt.expiration}" )
	private int expiration;

	@Value( "${security.jwt.secret}" )
	private String secret;

	public static final String ROLES = "authorities";

	//retrieve username from jwt token
	public String getUsernameFromToken( String token ) {
		return getClaimFromToken( token, Claims::getSubject );
	}

	//retrieve expiration date from jwt token
	public Date getExpirationDateFromToken( String token ) {
		return getClaimFromToken( token, Claims::getExpiration );
	}

	//retrieve expiration date from jwt token
	public Date getIssuedDateFromToken( String token ) {
		return getClaimFromToken( token, Claims::getIssuedAt );
	}

	public <T> T getClaimFromToken( String token, Function<Claims, T> claimsResolver ) {
		final Claims claims = getAllClaimsFromToken( token );
		return claimsResolver.apply( claims );
	}

	//for retrieving any information from token we will need the secret key
	public Claims getAllClaimsFromToken( String token ) {
		return Jwts.parser().setSigningKey( secret.getBytes() ).parseClaimsJws( token ).getBody();

	}

	//check if the token has expired
	private Boolean isTokenExpired( String token ) {
		final Date expirationDate = getExpirationDateFromToken( token );
		return expirationDate.before( new Date() );
	}

	//validate token
	public Boolean validateToken( String token ) {
		final String username = getUsernameFromToken( token );
		return username != null && !isTokenExpired( token );
	}

	public String getClientIpFromToken( String token ) {
		final Claims claims = getAllClaimsFromToken( token );

		return claims.get( "ip", String.class );
	}

	public Long getUserIdFromToken( String token ) {
		final Claims claims = getAllClaimsFromToken( token );

		return claims.get( "id", Long.class );
	}

	public static String getClientIp( HttpServletRequest request ) {
		String remoteAddr = "";
		if ( request != null ) {
			remoteAddr = request.getHeader( "X-FORWARDED-FOR" );
			if ( remoteAddr == null || "".equals( remoteAddr ) ) {
				remoteAddr = request.getRemoteAddr();
			}
		}
		return remoteAddr;
	}

	public UserPrincipal getUserPrincipal( String token ) {
		Claims claims = getAllClaimsFromToken( token );
		@SuppressWarnings( "unchecked" )
		List<String> authorities = claims.get( "authorities", List.class );
		@SuppressWarnings( "unchecked" )
		UserPrincipal userPrincipal = new UserPrincipal();
		userPrincipal.setId( Long.valueOf( claims.get( "id" ).toString() ) );
		userPrincipal.setUsername( claims.get( "sub" ).toString() );

		if ( authorities != null ) {
			userPrincipal.setAuthorities( authorities.stream().map( SimpleGrantedAuthority::new ).toList() );
		}

		return userPrincipal;
	}
}
