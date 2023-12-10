package com.pluck.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.ForgotPasswordRequestDto;
import com.pluck.dto.LoginFormDto;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.user.ChangePasswordDto;
import com.pluck.dto.user.SignUpRequestDto;
import com.pluck.security.JwtConfig;
import com.pluck.security.UserPrincipal;
import com.pluck.service.LoginService;
import com.pluck.service.NotificationService;
import com.pluck.service.SprintService;
import com.pluck.utilites.Cookies;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@AllArgsConstructor
@Slf4j
public class LoginController {

	private final LoginService loginService;
	private final ProjectUtilities projectUtilities;
	private final SprintService sprintService;
	private final NotificationService notificationService;
	private final DropdownCache dropdownCache;
	private final Cookies cookies;

	@Autowired
	private JwtConfig jwtConfig;

	@GetMapping( "/login" )
	public String loginForm( @RequestParam( required = false ) String errorMessage, HttpSession session, Model model, Authentication authentication ) {
		if ( errorMessage != null )
			model.addAttribute( Constants.ERROR_MSG, errorMessage );

		if ( authentication != null ) {

			LoginUserDto loggedInuser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
			return session.getAttribute( "role" ).toString().contentEquals( "Super Admin" ) ? "redirect:company?pageNo=0" : "redirect:/dashboard/user/" + loggedInuser.getId();
		}

		return Constants.LOGIN;
	}

	@PostMapping( "/login" )
	public String login( @ModelAttribute LoginFormDto loginRequestDto, Model model, HttpSession session, HttpServletResponse response, HttpServletRequest request ) {

		String token = loginService.login( loginRequestDto, JwtConfig.getClientIp( request ) );

		if ( token != null && !token.contains( "Bearer" ) ) {
			model.addAttribute( Constants.ERROR_MSG, token );
			return Constants.LOGIN;
		}
		if ( token == null ) {
			model.addAttribute( Constants.ERROR_MSG, "something wrong try again" );
			return Constants.LOGIN;
		}
		String authorizationHeader = token;
		String encodedAuthorization = URLEncoder.encode( authorizationHeader, StandardCharsets.UTF_8 );

		UserPrincipal userPricipal = jwtConfig.getUserPrincipal( token.replace( "Bearer", "" ).trim() );
		cookies.setCookie( response, "Authorization", encodedAuthorization );
		response.addHeader( "Authorization", authorizationHeader );

		LoginUserDto loggedInuser = loginService.loadLoggedInUser( token );
		String highestRole = loginService.getHighestRole( loggedInuser.getRole() );
		Integer highestRoleValue = loginService.getHigherRoleValue( highestRole );
		session.setAttribute( "highestRoleValue", highestRoleValue );
		session.setAttribute( "username", loginRequestDto.getUserName() );
		session.setAttribute( Constants.TOKEN, token );
		session.setAttribute( "role", highestRole );
		session.setAttribute( Constants.LOGGED_IN_USER, loggedInuser );
		List<ProjectDropdownResponseDto> projects = projectUtilities.getProjectDropdown( session, true );
		model.addAttribute( Constants.PROJECT_LIST, projects );

		UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken( userPricipal, null, userPricipal.getAuthorities() );
		SecurityContextHolder.getContext().setAuthentication( auth );

		if ( projects.isEmpty() ) {
			return highestRole.contentEquals( "Super Admin" ) ? "redirect:company?pageNo=0" : "redirect:/dashboard/user/" + loggedInuser.getId();
		}

		session.setAttribute( Constants.DEFAULT_PROJECT_ID, projects.get( 0 ).getId() );
		session.setAttribute( Constants.DEFAULT_PROJECT_NAME, projects.get( 0 ).getName() );

		cookies.setDefaultProject( response, projects.get( 0 ).getId(), projects.get( 0 ).getName() );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInuser.getCompanyId(), loggedInuser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		dropdownCache.loadStoryPoints( loggedInuser.getCompanyId(), token );
		dropdownCache.loadPriorites( loggedInuser.getCompanyId(), token );
		dropdownCache.loadSeverities( loggedInuser.getCompanyId(), token );
		dropdownCache.loadStatus( loggedInuser.getCompanyId(), token );

		return highestRole.contentEquals( "Super Admin" ) ? "redirect:company?pageNo=0" : "redirect:/dashboard/user/" + loggedInuser.getId();
	}

	@GetMapping( "/signUp" )
	public String getSignUpForm( HttpSession session, Model model ) {
		return "login/signUp";
	}

	@PostMapping( "/sign-up" )
	public String signUp( @ModelAttribute SignUpRequestDto signUpDto, HttpSession session, Model model, RedirectAttributes ra ) {

		String isAdded = loginService.signUp( signUpDto );

		if ( Constants.ADD_USER_SUCCESS.equals( isAdded ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isAdded );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, isAdded );
		return "redirect:/signUp";
	}

	@GetMapping( "/changePassword" )
	public String getChangePasswordForm( HttpSession session, Model model ) {
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "login/changePassword";
	}

	@PostMapping( "/change-password" )
	public String changePassword( @ModelAttribute ChangePasswordDto changePassDto, HttpSession session, Model model, RedirectAttributes ra ) {

		String isAdded = loginService.changePassword( changePassDto, ( String ) session.getAttribute( Constants.TOKEN ) );
		ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isAdded );
		if ( "Password updated successfully".equals( isAdded ) ) {
			return "redirect:/logout";
		}
		return "redirect:/changePassword";
	}

	@GetMapping( "/forgotPassword" )
	public String getForgotPasswordForm( HttpSession session, Model model ) {
		return "login/forgotPassword";
	}

	@PostMapping( "/forgot-password" )
	public String forgotPassword( @ModelAttribute ForgotPasswordRequestDto requestDto, HttpSession session, Model model, RedirectAttributes ra ) {
		String isAdded = loginService.forgotPassword( requestDto );
		String status = "User doesn't exists";
		if ( isAdded.equals( status ) ) {
			model.addAttribute( Constants.ERROR_MSG, isAdded );
			return "login/forgotPassword";
		} else {
			ra.addFlashAttribute( Constants.MESSAGE, isAdded );
		}
		return "redirect:/forgotPassword";
	}
}
