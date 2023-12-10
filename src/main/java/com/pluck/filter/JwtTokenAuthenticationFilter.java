package com.pluck.filter;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.ObjectUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import com.pluck.constants.Constants;
import com.pluck.controller.DropdownCache;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.security.JwtConfig;
import com.pluck.security.UserPrincipal;
import com.pluck.service.LoginService;
import com.pluck.service.SprintService;
import com.pluck.service.UserService;
import com.pluck.utilites.Cookies;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@AllArgsConstructor
public class JwtTokenAuthenticationFilter extends OncePerRequestFilter {

	private final JwtConfig jwtConfig;

	private final HttpHeaders httpHeaders;

	private final UserService userService;

	private final LoginService loginService;

	private final ProjectUtilities projectUtilities;

	private final DropdownCache dropdownCache;

	private final SprintService sprintService;

	private final Cookies cookies;

	@Override
	protected void doFilterInternal( @NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull FilterChain chain ) throws ServletException, IOException {
		String header = request.getHeader( jwtConfig.getHeader() );

		if ( header == null || !header.startsWith( jwtConfig.getPrefix() ) ) {
			if ( !ObjectUtils.isEmpty( request.getCookies() ) ) {
				String authCookie = cookies.getCookieValue( request, Constants.AUTHORIZATION );

				if ( authCookie != null ) {
					header = URLDecoder.decode( authCookie, StandardCharsets.UTF_8 );
					if ( header != null && !header.isBlank() ) {
						try {
							String token = header.replace( jwtConfig.getPrefix(), "" ).trim();
							UserPrincipal userPrincipal = jwtConfig.getUserPrincipal( token );
							LoginUserDto loggedInuser = loginService.loadLoggedInUser( header );
							if ( Boolean.TRUE.equals( jwtConfig.validateToken( token ) ) /*&& jwtConfig.getClientIpFromToken( token ).equals( JwtConfig.getClientIp( request ) )*/ && userService.getInvalidTokens( loggedInuser.getUserName(), loggedInuser.getId(), token ).stream().filter( invalidToken -> invalidToken.getToken().contentEquals( token ) ).count() == 0 && ( loggedInuser.getTokenResetTime() == null || Date.from( loggedInuser.getTokenResetTime().atZone( ZoneId.systemDefault() ).toInstant() ).before( jwtConfig.getIssuedDateFromToken( token ) ) ) ) {
								String highestRole = loginService.getHighestRole( loggedInuser.getRole() );
								Integer highestRoleValue = loginService.getHigherRoleValue( highestRole );
								request.getSession().setAttribute( "highestRoleValue", highestRoleValue );
								request.getSession().setAttribute( "username", loggedInuser.getUserName() );
								request.getSession().setAttribute( Constants.TOKEN, header );
								request.getSession().setAttribute( "role", highestRole );
								request.getSession().setAttribute( Constants.LOGGED_IN_USER, loggedInuser );

								String projectId = cookies.getCookieValue( request, Constants.DEFAULT_PROJECT_ID );
								String projectName = cookies.getCookieValue( request, Constants.DEFAULT_PROJECT_NAME );

								if ( projectId == null || projectId.isEmpty() ) {
									List<ProjectDropdownResponseDto> projects = projectUtilities.getProjectDropdown( request.getSession(), true );
									if ( !projects.isEmpty() ) {
										request.getSession().setAttribute( Constants.DEFAULT_PROJECT_ID, projects.get( 0 ).getId() );
										request.getSession().setAttribute( Constants.DEFAULT_PROJECT_NAME, projects.get( 0 ).getName() );
									}
								} else {
									request.getSession().setAttribute( Constants.DEFAULT_PROJECT_ID, Long.valueOf( projectId ) );
									request.getSession().setAttribute( Constants.DEFAULT_PROJECT_NAME, projectName == null ? "" : projectName );
								}

								userPrincipal.setCompanyId( loggedInuser.getCompanyId() );
								userPrincipal.setName( loggedInuser.getFirstName() + " " + loggedInuser.getLastName() );
								userPrincipal.setUsername( userPrincipal.getUsername() );
								if ( dropdownCache.storyPoints == null )
									dropdownCache.loadStoryPoints( loggedInuser.getCompanyId(), token );
								if ( dropdownCache.priorities == null )
									dropdownCache.loadPriorites( loggedInuser.getCompanyId(), token );
								if ( dropdownCache.severities == null )
									dropdownCache.loadSeverities( loggedInuser.getCompanyId(), token );
								if ( dropdownCache.status == null )
									dropdownCache.loadStatus( loggedInuser.getCompanyId(), token );
								UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken( userPrincipal, null, userPrincipal.getAuthorities() );
								SecurityContextHolder.getContext().setAuthentication( auth );
								response.setHeader( Constants.ATTR_AUTHORIZATION, header );

							} else {

								cookies.deleteCookies( response );
								response.sendRedirect( request.getContextPath() + "/login" );
								return;
							}

						} catch ( Exception e ) {
							SecurityContextHolder.clearContext();
						}

					}
				}
			}
		}

		chain.doFilter( request, response );
	}

}
