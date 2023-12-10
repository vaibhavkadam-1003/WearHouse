package com.pluck.filter;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.ZoneId;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.util.ObjectUtils;

import com.pluck.constants.Constants;
import com.pluck.dto.user.InvalidTokenDto;
import com.pluck.security.JwtConfig;
import com.pluck.security.UserPrincipal;
import com.pluck.service.UserService;
import com.pluck.utilites.Cookies;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

	private JwtConfig jwtConfig;

	private UserService userService;

	private Cookies cookies;

	public CustomLogoutSuccessHandler(JwtConfig jwtConfig, UserService userService, Cookies cookies ) {
		this.jwtConfig = jwtConfig;
		this.userService = userService;
		this.cookies = cookies;
	}

	@Override
	public void onLogoutSuccess( HttpServletRequest request, HttpServletResponse response, Authentication authentication ) throws IOException, ServletException {
		if ( !ObjectUtils.isEmpty( request.getCookies() ) ) {
			String authCookie = cookies.getCookieValue( request.getCookies(), Constants.AUTHORIZATION );

			if ( authCookie != null && !authCookie.isEmpty() ) {
				String header = URLDecoder.decode( authCookie, StandardCharsets.UTF_8 );

				if ( header != null && !header.isBlank() ) {
					String token = header.replace( jwtConfig.getPrefix(), "" );
					UserPrincipal userPrincipal = jwtConfig.getUserPrincipal( token );

					InvalidTokenDto invalidToken = new InvalidTokenDto();
					invalidToken.setToken( token );
					invalidToken.setExpiryDate( Instant.ofEpochMilli( jwtConfig.getExpirationDateFromToken( token ).getTime() )
							.atZone( ZoneId.systemDefault() )
							.toLocalDateTime() );
					invalidToken.setUserId( userPrincipal.getId() );
					userService.saveInvalidTokenDtos( invalidToken, userPrincipal.getUsername(), userPrincipal.getId() );
				}
			}
		}

		cookies.deleteCookies( response );
		response.sendRedirect( request.getContextPath() + "/login" );
	}
}
