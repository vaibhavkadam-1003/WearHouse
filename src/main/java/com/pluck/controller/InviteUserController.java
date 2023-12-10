package com.pluck.controller;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.inviteUser.Content;
import com.pluck.model.InvitatedUser;
import com.pluck.service.InviteUserService;
import com.pluck.service.NotificationService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/invite" )
@Controller
@AllArgsConstructor
public class InviteUserController {

	private final InviteUserService inviteUserService;
	private final ProjectUtilities projectUtilities;
	private final NotificationService notificationService;

	@GetMapping( "/inviteUserForm" )
	public String addForm( Model model, HttpSession session, @ModelAttribute( "message" ) String message ) throws URISyntaxException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<Content> list = inviteUserService.findAll( token );
		model.addAttribute( "list", list );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "users/inviteUser";
	}

	@GetMapping( "/getInvitedUsers" )
	public String getAllInvitedUsers( Model model, HttpSession session, @ModelAttribute( "message" ) String message ) throws URISyntaxException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<Content> list = inviteUserService.findAll( token );
		model.addAttribute( "list", list );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "users/allinvitedUsers";
	}

	@PostMapping
	public String add( @ModelAttribute InvitatedUser invitatedUser, HttpSession session, Model model, RedirectAttributes ra ) {
		Map<String, List<String>> result = inviteUserService.invite( invitatedUser, ( String ) session.getAttribute( Constants.TOKEN ) );
		List<String> errorList = result.get( "error" );
		List<String> successList = result.get( "success" );
		String successListString = removeComma( successList );
		String errorListString = removeComma( errorList );
		String errorMessage = null;

		if ( !errorList.isEmpty() && !successList.isEmpty() ) {
			errorMessage = errorListString + ",  " + successListString;
		} else if ( !errorList.isEmpty() ) {
			errorMessage = errorListString;
		} else
			errorMessage = successListString;

		String regex = Constants.INVITE_SUCCESS;

		Pattern pattern = Pattern.compile( regex );
		Matcher matcher = pattern.matcher( errorMessage );

		if ( matcher.find() )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, errorMessage );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, errorMessage );

		return "redirect:/users/add/form";

	}

	public static String removeComma( List<String> list ) {
		List<String> emailList = list;

		String arrayListString = emailList.toString(); // Convert ArrayList to string
		arrayListString = arrayListString.substring( 1, arrayListString.length() - 1 ); // Remove enclosing brackets []

		int lastCommaIndex = arrayListString.lastIndexOf( "," );
		if ( lastCommaIndex >= 0 ) {
			arrayListString = arrayListString.substring( 0, lastCommaIndex ) + arrayListString.substring( lastCommaIndex + 1 );
		}

		return arrayListString;
	}

}