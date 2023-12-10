package com.pluck.security;

import static org.springframework.security.config.Customizer.withDefaults;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.pluck.constants.Constants;
import com.pluck.controller.DropdownCache;
import com.pluck.filter.CustomLogoutSuccessHandler;
import com.pluck.filter.JwtTokenAuthenticationFilter;
import com.pluck.service.LoginService;
import com.pluck.service.SprintService;
import com.pluck.service.UserService;
import com.pluck.utilites.Cookies;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	private static final String COMPANY_ADMIN = "Company Admin";
	private static final String PROJECT_LEAD = "Project Lead";
	private static final String PROJECT_USER = "Project User";
	private static final String SUPER_ADMIN = "Super Admin";
	private static final String SCRUM_MASTER = "Scrum Master";
	private static final String PROJECT_MANAGER = "Project Manager";

	@Autowired
	private UserService userService;

	@Autowired
	private LoginService loginService;

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private DropdownCache dropdownCache;

	@Autowired
	private SprintService sprintService;

	@Autowired
	private Cookies cookies;

	@Bean
	SecurityFilterChain filterChain( HttpSecurity http, JwtConfig jwtConfig, HttpHeaders httpHeaders ) throws Exception {
		http
				.csrf( csrf -> csrf.disable() )
				.sessionManagement( management -> management
						.sessionCreationPolicy( SessionCreationPolicy.STATELESS ) )
				.exceptionHandling( handling -> {
					handling.authenticationEntryPoint( ( req, rsp, e ) -> rsp.sendError( HttpServletResponse.SC_UNAUTHORIZED ) );
				} )
				.logout( logout -> logout
						.clearAuthentication( true )
						.invalidateHttpSession( true )
						.deleteCookies( Constants.ATTR_AUTHORIZATION )
						.logoutUrl( "/logout" )
						.logoutSuccessHandler( new CustomLogoutSuccessHandler( jwtConfig, userService, cookies ) ) )

				.exceptionHandling( handling -> {
					handling.authenticationEntryPoint( new LoginUrlAuthenticationEntryPoint( "/login" ) );
				} )
				.addFilterAfter( new JwtTokenAuthenticationFilter( jwtConfig, httpHeaders, userService, loginService, projectUtilities, dropdownCache, sprintService, cookies ), UsernamePasswordAuthenticationFilter.class )
				.authorizeHttpRequests()
				.requestMatchers( "/css/landing.css", "/css/**" ).permitAll()
				.requestMatchers( "/images/**" ).permitAll()
				.requestMatchers( "/images/" ).permitAll()
				.requestMatchers( "/js/**" ).permitAll()
				.requestMatchers( "/" ).permitAll()
				.requestMatchers( "/resources/**" ).permitAll()
				.requestMatchers( "/WEB-INF/**" ).permitAll()
				.requestMatchers( "/error" ).permitAll()
				.requestMatchers( "/login", "/forgotPassword", "/signUp" ).permitAll()
				.requestMatchers( "/dashboard/**", "/users/update/form/**", "/changePassword", "/notification/details/**" ).hasAnyRole( SCRUM_MASTER, SUPER_ADMIN, COMPANY_ADMIN, PROJECT_LEAD, PROJECT_USER, SCRUM_MASTER, PROJECT_MANAGER )
				.requestMatchers( "/company/**" ).hasAnyRole( SUPER_ADMIN )
				.requestMatchers( "/scrums/**" ).hasAnyRole( COMPANY_ADMIN, SCRUM_MASTER, PROJECT_MANAGER, PROJECT_LEAD, PROJECT_USER )
				.requestMatchers( "/tasks/**", "/stories/**", "/backlogs", "/sprints/**", "/reports/**", "/projects/allproject", "/projects/details/**", "/projects/project/dashboard/**", "/projects/default", "/users/getUsersProject", "/projects/allproject/**" ).hasAnyRole( COMPANY_ADMIN, SCRUM_MASTER, PROJECT_LEAD, PROJECT_MANAGER, PROJECT_USER )
				.requestMatchers( "/users/getUsersProject", "/projects/**" ).hasAnyRole( COMPANY_ADMIN, SCRUM_MASTER, PROJECT_LEAD, PROJECT_MANAGER, PROJECT_USER )
				.requestMatchers( "/users/add/form/", "/users/update/form/**", "/projects/add/form", "/tasks/**", "/stories/**", "/backlogs", "/sprints/**", "projects/details/**" ).hasAnyRole( COMPANY_ADMIN, PROJECT_MANAGER, PROJECT_LEAD )
				.requestMatchers( "/forgot-password/**" ).permitAll()
				.requestMatchers( "/sign-up/**" ).permitAll()
				.requestMatchers( "/checkUserExistingEmailId" ).permitAll()
				.anyRequest().authenticated().and().exceptionHandling( withDefaults() );

		return http.build();
	}

	@Bean
	JwtConfig jwtConfig() {
		return new JwtConfig();
	}
}
