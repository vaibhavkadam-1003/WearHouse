package com.pluck.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.NotificationService;
import com.pluck.service.SprintReportService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@Controller
@RequestMapping( "/reports" )
@AllArgsConstructor
public class SprintReportController {

	@Autowired
	private final NotificationService notificationService;

	@Autowired
	private final ProjectUtilities projectUtilities;

	@Autowired
	private final SprintReportService sprintReportService;

	@GetMapping( "/getSprintName" )
	public String findCurrentSprint( HttpSession session, Model model, RedirectAttributes ra ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );

		List<SprintDto> sprints = sprintReportService.findAllSprintsByCompanyAndProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( "sprints", sprints );

		List<TaskDto> completedTasks = sprintReportService.findCompletedTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, currentSprint );
		model.addAttribute( "completedTasks", completedTasks );

		List<TaskDto> inCompletedTasks = sprintReportService.findInCompletedTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, currentSprint );
		model.addAttribute( "inCompletedTasks", inCompletedTasks );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "reports/sprintList";
	}

	@ResponseBody
	@GetMapping( "/current-sprint-user-report" )
	public List<SprintUserChartDetailsDto> currentSprintUserReport( @RequestParam Integer sprintId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintReportService.currentSprintUserReport( loggedInUser.getCompanyId(), defaultProjectId, sprintId, token );
	}

	@GetMapping( "/sprintReportById" )
	public String sprintReportsById( HttpSession session, Model model, @RequestParam( "sprintId" ) String sprintId ) {

		Integer selectedSprint = Integer.parseInt( sprintId );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		List<TaskDto> completedTasks = sprintReportService.findCompletedTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, selectedSprint );
		model.addAttribute( "completedTasks", completedTasks );

		List<TaskDto> inCompletedTasks = sprintReportService.findInCompletedTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, selectedSprint );
		model.addAttribute( "inCompletedTasks", inCompletedTasks );

		String sprintName = sprintReportService.findBySprintNameById( selectedSprint, token );
		model.addAttribute( "sprintName", sprintName );

		Integer totalCount = sprintReportService.countByTotalTasks( loggedInUser.getCompanyId(), defaultProjectId, selectedSprint, token );
		Integer completedTasksCount = sprintReportService.countAllCompletedTasks( loggedInUser.getCompanyId(), defaultProjectId, selectedSprint, token );

		model.addAttribute( "totalTasksCount", totalCount );
		model.addAttribute( "completedTasksCount", completedTasksCount );
		model.addAttribute( "incompletedTasksCount", totalCount - completedTasksCount );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( "selectedSprintId", selectedSprint );
		return "reports/sprintReport";
	}
}