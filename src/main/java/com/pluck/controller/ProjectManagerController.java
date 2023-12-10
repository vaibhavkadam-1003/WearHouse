package com.pluck.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.sprint.ActiveSprintsDto;
import com.pluck.dto.sprint.SprintHistoryResponseDto;
import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectManagerService;
import com.pluck.service.SprintService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping( "/project-manager" )
public class ProjectManagerController {

	@Autowired
	private ProjectManagerService projectManagerService;

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private SprintService sprintService;

	@GetMapping( "/dashboard" )
	public String dashboard( HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Map<String, List<ScrumTeamResponseDto>> scrumTeams = projectManagerService.findAllScrumTeamsByProjectManager( loggedInUser.getCompanyId(), loggedInUser.getId(), token );
		model.addAttribute( "scrumTeams", scrumTeams );

		List<UserResponseDTO> scrumMasters = projectManagerService.findScrumMastersByProjectManager( loggedInUser.getCompanyId(), loggedInUser.getId(), token );
		model.addAttribute( "scrumMasters", scrumMasters );

		List<ActiveSprintsDto> activeSprints = sprintService.findActiveSprintsForUser( loggedInUser.getCompanyId(), loggedInUser.getId(), token );
		model.addAttribute( "activeSprints", activeSprints );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		model.addAttribute( Constants.PAGE_TITLE, "Dashboard" );
		return "dashboards/projectManagerDashboard";
	}

	@ResponseBody
	@GetMapping( "/previous-sprints/{projectId}" )
	public List<SprintDto> previousSprints( @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.findPreviousSprints( token, loggedInUser.getCompanyId(), projectId );
	}

	@GetMapping( "/sprint-history/{projectId}/{sprintId}" )
	public String sprintHistory( Model model, HttpSession session, @PathVariable Long projectId, @PathVariable Integer sprintId ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		List<SprintHistoryResponseDto> list = sprintService.findHistoryById( token, projectId, sprintId );
		int totalTasks = 0;
		int completedTasks = 0;
		int incompletedTasks = 0;
		int totalStoryPoints = 0;
		int completedStoryPoints = 0;
		int incompleteStoryPoints = 0;
		List<String> completeStatus = Arrays.asList( "Resolved" );
		for ( SprintHistoryResponseDto dto : list ) {
			totalTasks = totalTasks + 1;
			totalStoryPoints = totalStoryPoints + dto.getStoryPoints();
			if ( completeStatus.contains( dto.getTaskStatus() ) ) {
				completedTasks = completedTasks + 1;
				completedStoryPoints = completedStoryPoints + dto.getStoryPoints();
			} else {
				incompletedTasks = incompletedTasks + 1;
				incompleteStoryPoints = incompleteStoryPoints + dto.getStoryPoints();
			}
		}
		List<ScrumTeamResponseDto> teams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), sprintId, token );
		model.addAttribute( "totalTasks", totalTasks );
		model.addAttribute( "completedTasks", completedTasks );
		model.addAttribute( "incompletedTasks", incompletedTasks );
		model.addAttribute( "totalStoryPoints", totalStoryPoints );
		model.addAttribute( "completedStoryPoints", completedStoryPoints );
		model.addAttribute( "incompletedStoryPoints", incompleteStoryPoints );
		model.addAttribute( "sprintId", sprintId );
		model.addAttribute( "teams", teams );
		model.addAttribute( "sprintId", sprintId );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "dashboards/sprintHistory";
	}

	@ResponseBody
	@GetMapping( "/sprint-history-user-chart-details" )
	public List<SprintUserChartDetailsDto> sprintHistoryserChartDetails( @RequestParam Integer sprintId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		SprintDto sprint = sprintService.findById( sprintId, token );
		return sprintService.findSprintHistoryUserChartDetails( loggedInUser.getCompanyId(), sprint.getProject(), sprintId, token );
	}

}
