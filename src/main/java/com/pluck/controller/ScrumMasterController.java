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
import org.springframework.web.bind.annotation.ResponseBody;

import com.pluck.constants.Constants;
import com.pluck.constants.ViewConstants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.report.ProjectCountReport;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.dto.task.TaskPagerDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ScrumMasterService;
import com.pluck.service.SprintService;
import com.pluck.service.TaskService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping( "/scrum-master" )
@Slf4j
public class ScrumMasterController {

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private ScrumMasterService scrumMasterService;

	@Autowired
	private TaskService taskService;

	@Autowired
	private SprintService sprintService;

	@Autowired
	private NotificationService notificationService;

	@GetMapping( "/dashboard" )
	public String dashBoard( HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );

		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Map<String, List<ScrumTeamResponseDto>> scrumTeams = scrumMasterService.findAllScrumTeamsForScrumMaster( loggedInUser.getCompanyId(), loggedInUser.getId(), token );
		model.addAttribute( "scrumTeams", scrumTeams );
		model.addAttribute( Constants.DEFAULT_PROJECT_ID, defaultProjectId );
		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( dto == null )
			model.addAttribute( "currentSprintStatus", true );
		else
			model.addAttribute( "currentSprintStatus", false );
		try {
			List<ProjectCountReport> prjectReport = scrumMasterService.findProjectCountReportByScrumMaster( loggedInUser.getCompanyId(), loggedInUser.getId(), token );
			model.addAttribute( "projectReports", prjectReport );
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		return "dashboards/scrumMasterDashboard";
	}

	@ResponseBody
	@GetMapping( "/project/task-count/{projectId}" )
	public Map<String, Integer> findTaskCountForProject( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumMasterService.findTaskCountForProject( loggedInUser.getCompanyId(), projectId, token );

	}

	@ResponseBody
	@GetMapping( "/project/story-point-count/{projectId}" )
	public Map<String, Integer> findStoryPointCountForProject( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumMasterService.findStoryPointCountForProject( loggedInUser.getCompanyId(), projectId, token );

	}

	@ResponseBody
	@GetMapping( "/top-five-tasks/{projectId}" )
	public List<TaskDto> getAllTasksByUser( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return taskService.getTop5TasksByUser( token, loggedInUser.getId(), projectId,
				loggedInUser.getCompanyId() );
	}

	@GetMapping( "/all-task/{projectId}" )
	public String getAllTask( @PathVariable Long projectId, HttpSession session, Model model ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		int pageNo = 0;
		if ( projectId != null ) {
			TaskPagerDto list = taskService.allTaskByActiveSprint( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
					loggedInUser.getCompanyId(), projectId );
			model.addAttribute( Constants.TASK_LIST, list );
			List<String> selectedStatus = Arrays.asList( "None" );
			model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.ALL_TASKS;
	}

	@GetMapping( "/all-task-active-sprint/{projectId}" )
	public String getAllTaskForSprint( @PathVariable Long projectId, HttpSession session, Model model ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		int pageNo = 0;
		if ( projectId != null ) {
			TaskPagerDto list = taskService.allTaskByActiveSprint( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
					loggedInUser.getCompanyId(), projectId );
			model.addAttribute( Constants.TASK_LIST, list );
			List<String> selectedStatus = Arrays.asList( "None" );
			model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "tasks/dashboardAllTask";
	}

	@GetMapping( "/completed-task/{projectId}" )
	public String getCompletedTasks( @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		int pageNo = 0;
		if ( projectId != null ) {
			TaskPagerDto list = taskService.getAllCompletedTask( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
					loggedInUser.getCompanyId(), projectId );
			model.addAttribute( Constants.TASK_LIST, list );
			List<String> selectedStatus = Arrays.asList( "None" );
			model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "tasks/dashboardAllTask";
	}

	@GetMapping( "/inComplete-task/{projectId}" )
	public String getInCompletedTasks( @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		int pageNo = 0;
		if ( projectId != null ) {
			TaskPagerDto list = taskService.getAllInCompleteTask( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
					loggedInUser.getCompanyId(), projectId );
			model.addAttribute( Constants.TASK_LIST, list );
			List<String> selectedStatus = Arrays.asList( "None" );
			model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "tasks/dashboardAllTask";
	}

}