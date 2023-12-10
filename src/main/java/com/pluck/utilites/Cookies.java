package com.pluck.utilites;

import java.util.Arrays;

import org.springframework.stereotype.Service;

import com.pluck.constants.Constants;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class Cookies {

	public void setDefaultProject( HttpServletResponse response, Long projectId, String projectName ) {
		response.addCookie( createCookie( Constants.DEFAULT_PROJECT_ID, String.valueOf( projectId ) ) );
		response.addCookie( createCookie( Constants.DEFAULT_PROJECT_NAME, projectName.replaceAll( " ", "" ) ) );
	}

	public void setCookie( HttpServletResponse response, String name, String value ) {
		response.addCookie( createCookie( name, value ) );
	}

	public Cookie createCookie( String name, String value ) {
		Cookie cookie = new Cookie( name, value );
		cookie.setHttpOnly( true );
		cookie.setSecure( true );
		cookie.setPath( "/" );
		return cookie;
	}

	public String getCookieValue( Cookie[] userCookies, String name ) {
		Cookie cookie = getCookie( userCookies, name );
		if ( cookie == null )
			return null;
		return cookie.getValue();
	}

	public String getCookieValue( HttpServletRequest request, String name ) {
		return getCookieValue( request.getCookies(), name );
	}

	public Cookie getCookie( HttpServletRequest request, String name ) {
		return getCookie( request.getCookies(), name );
	}

	public Cookie getCookie( Cookie[] userCookies, String name ) {
		return Arrays.stream( userCookies ).filter( cookie -> cookie.getName().equalsIgnoreCase( name ) ).findFirst().orElse( null );
	}

	public void removeDefaultProject( HttpServletResponse response ) {
		response.addCookie( createCookie( Constants.DEFAULT_PROJECT_ID, null ) );
		response.addCookie( createCookie( Constants.DEFAULT_PROJECT_NAME, null ) );
	}

	public void deleteCookies( HttpServletResponse response ) {
		setCookie( response, Constants.ATTR_AUTHORIZATION, null );
		setCookie( response, Constants.DEFAULT_PROJECT_NAME, null );
		setCookie( response, Constants.DEFAULT_PROJECT_ID, null );
	}

}
