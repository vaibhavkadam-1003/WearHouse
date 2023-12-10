package com.pluck.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.constants.ViewConstants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.task.AcceptanceCriteriaDto;
import com.pluck.service.AcceptanceCriteriaService;
import com.pluck.service.NotificationService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping( "/criterias" )
public class AcceptanceCriteriaController {

	@Autowired
	private AcceptanceCriteriaService criteriaService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private ProjectUtilities projectUtilities;

	@GetMapping( "/addCriteriaForm" )
	public String addSprintForm( Model model, HttpSession session ) {
		model.addAttribute( "projectList", projectUtilities.getProjectDropdown( session, false ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( "notifications", notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "tasks/addCriteria";
	}

	@PostMapping
	public String add( @ModelAttribute AcceptanceCriteriaDto dto, HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, "Set default project to add Sprint" );
			return "tasks/addSprint";
		}
		AcceptanceCriteriaDto addStatus = criteriaService.add( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( addStatus == null )
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.ADD_CRITERIA_ERROR );
		else
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.ADD_CRITERIA_SUCCESS );
		return ViewConstants.REDIRECT_TO_ALL_TASK;
	}

	@PostMapping( "/dynamic" )
	@ResponseBody
	public AcceptanceCriteriaDto addCriteria( @RequestBody AcceptanceCriteriaDto dto, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( "loggedInUser" );
		Long defaultProjectId = ( Long ) session.getAttribute( "defaultProjectId" );
		String token = ( String ) session.getAttribute( "token" );
		return criteriaService.add( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
	}
}
