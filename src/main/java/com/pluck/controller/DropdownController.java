package com.pluck.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.service.DropdownService;
import com.pluck.service.NotificationService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@Controller
@RequestMapping( "/dropdownConfiguration" )
@AllArgsConstructor
public class DropdownController {

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private DropdownCache dropdownCache;

	@Autowired
	private DropdownService dropdownService;

	@GetMapping( "/priority/form" )
	public String getPriorityForm( HttpSession session, Model model ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );

		model.addAttribute( "priorities", dropdownCache.getPriorities( defaultProjectId ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "configuration/priorityConfiguration";
	}

	@PostMapping( "/save" )
	@ResponseBody
	public List<PriorityConfigurationDto> savePriority( @RequestBody PriorityConfigurationDto dto, HttpSession session ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<PriorityConfigurationDto> status = dropdownService.savePriority( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		dropdownCache.loadPriorites( loggedInUser.getCompanyId(), token );
		return status;
	}

	@ResponseBody
	@GetMapping( "/{id}" )
	public String delete( @PathVariable Long id, HttpSession session, RedirectAttributes rs ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		long deletePriority = dropdownService.delete( id, token );
		if ( deletePriority > 0 ) {
			dropdownCache.loadPriorites( loggedInUser.getCompanyId(), token );
			return "Priority deleted successfully";
		} else {
			return "Priority not deleted";
		}
	}

	@GetMapping( "/severity/form" )
	public String getSeverityForm( HttpSession session, Model model ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		model.addAttribute( "projectList", projectUtilities.getProjectDropdown( session, false ) );

		model.addAttribute( "severities", dropdownCache.getSeverities( defaultProjectId ) );

		model.addAttribute( "notifications", notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "configuration/severityConfiguration";
	}

	@PostMapping( "/saveSeverity" )
	@ResponseBody
	public List<SeverityConfigurationDto> saveSeverity( @RequestBody SeverityConfigurationDto dto, HttpSession session ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<SeverityConfigurationDto> status = dropdownService.saveSeverity( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		dropdownCache.loadSeverities( loggedInUser.getCompanyId(), token );
		return status;
	}

	@ResponseBody
	@GetMapping( "/deleteSeverity/{id}" )
	public String deleteSeverity( @PathVariable Long id, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		long deleteSeverity = dropdownService.deleteSeverity( id, token );
		if ( deleteSeverity > 0 ) {
			dropdownCache.loadSeverities( loggedInUser.getCompanyId(), token );
			return "Severity deleted successfully";
		} else {
			return "Severity not deleted";
		}
	}

	@GetMapping( "/status/form" )
	public String getStatusForm( HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		model.addAttribute( "projectList", projectUtilities.getProjectDropdown( session, false ) );

		model.addAttribute( "statuses", dropdownCache.getStatuses( defaultProjectId ) );

		model.addAttribute( "notifications", notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "configuration/statusConfiguration";
	}

	@PostMapping( "/saveStatus" )
	@ResponseBody
	public List<StatusConfigurationDto> saveStatus( @RequestBody StatusConfigurationDto dto, HttpSession session ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<StatusConfigurationDto> status = dropdownService.saveStatus( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		dropdownCache.loadStatus( loggedInUser.getCompanyId(), token );
		return status;
	}

	@ResponseBody
	@GetMapping( "/deleteStatus/{id}" )
	public String deleteStatus( HttpSession session, Model model, @PathVariable Long id ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		long deleteStatus = dropdownService.deleteStatus( id, token );
		if ( deleteStatus > 0 ) {
			dropdownCache.loadStatus( loggedInUser.getCompanyId(), token );
			return "Status delete successfully";
		} else {
			return "Status not deleted";
		}
	}
}
