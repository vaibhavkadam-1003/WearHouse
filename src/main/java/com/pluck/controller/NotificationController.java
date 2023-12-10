
package com.pluck.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.notification.NotificationResponceDto;
import com.pluck.service.NotificationService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/notification" )
@Controller
@AllArgsConstructor
public class NotificationController {

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private ProjectUtilities projectUtilities;

	@ResponseBody
	@GetMapping( "/{id}" )
	public String delete( @PathVariable Long id, HttpSession session, RedirectAttributes rs ) {

		long deleteNotification = notificationService.delete( id, ( String ) session.getAttribute( Constants.TOKEN ) );

		if ( deleteNotification > 0 ) {
			return "Notication deleted successfully";
		} else {
			return "Notication not deleted";
		}

	}

	@ResponseBody
	@GetMapping( "/deleteAll" )
	public String deleteAll( HttpSession session, RedirectAttributes rs ) {

		LoginUserDto loggedInuser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		long deleteAllNotification = notificationService.deleteAll( loggedInuser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) );

		if ( deleteAllNotification > 0 ) {
			return "Notication deleted successfully";
		} else {
			return "Notication not deleted";
		}

	}

	@GetMapping( "/details/{id}" )
	public String getNotificationDetailsForm( HttpSession session, Model model, @PathVariable Long id ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		NotificationResponceDto notificationList = notificationService.getNotificationById( id, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( "notificationList", notificationList );

		return "notification/notificationOverview";
	}

}
