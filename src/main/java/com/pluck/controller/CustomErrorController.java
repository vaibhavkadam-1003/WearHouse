package com.pluck.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class CustomErrorController implements ErrorController {

	@RequestMapping( "/error" )
	public String handleError( HttpServletRequest request, Model model, HttpSession session ) {
		Object status = request.getAttribute( RequestDispatcher.ERROR_STATUS_CODE );
		int statusCode = Integer.valueOf( status.toString() );
		model.addAttribute( "statusCode", status );
		LoginUserDto loggedInuser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		if ( loggedInuser == null ) {
			model.addAttribute( "url", "" );
		} else {
			model.addAttribute( "url", "dashboard/user/" + loggedInuser.getId() );
		}

		String statusHeader = "Something went wrong...!";
		String statusMessage = "The page you are looking for might have been removed had its name changed or is temporarily unavailable.";
		if ( statusCode == 404 ) {
			statusHeader = "Page Not Found!.";
			statusMessage = "You're either mispelling the URL or requesting a page that's  no longer here.";
		}

		if ( statusCode == 400 ) {
			statusHeader = "You have sent a bad request!.";
			statusMessage = "";
		}

		if ( statusCode == 403 ) {
			statusHeader = "Permission Denied!.";
			statusMessage = "Sorry, you don't have access to access this page. please contact your administrator.";
		}

		model.addAttribute( "statusHeader", statusHeader );
		model.addAttribute( "statusMessage", statusMessage );
		return "error";
	}

}