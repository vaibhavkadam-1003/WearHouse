package com.pluck.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.project.Content;
import com.pluck.dto.project.ProjectPagerDto;
import com.pluck.dto.project.ProjectResDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.sprint.ActiveSprintsDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.dto.task.TaskPagerDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectService;
import com.pluck.service.ScrumMasterService;
import com.pluck.service.SprintService;
import com.pluck.service.TaskService;
import com.pluck.service.UserService;
import com.pluck.service.UserStoryService;
import com.pluck.utilites.ProjectUtilities;
import com.pluck.utilites.SprintUtility;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping( "/dashboard" )
@Slf4j
@AllArgsConstructor
public class DashboardController {

	private final ProjectUtilities projectUtilities;
	private final TaskService taskService;
	private final UserStoryService userStoryService;
	private final ProjectService projectService;
	private final UserService userService;
	private final ScrumMasterService scrumMasterService;
	private final SprintService sprintService;
	private final SprintUtility sprintUtility;
	private final NotificationService notificationService;

	@GetMapping( "/user/{userId}" )
	public String dashboard( Model model, HttpSession session, RedirectAttributes ra, @PathVariable Long userId ) {
		session.setAttribute( "userId", userId );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				userId, token ) );
		List<TaskDto> taskList = taskService.getTop5TasksByUser( token, userId, defaultProjectId,
				loggedInUser.getCompanyId() );
		List<ProjectResponseDto> projectListByUser = projectService.topFiveProjectsByUser( token,
				userId, loggedInUser.getCompanyId() );

		List<ActiveSprintsDto> activeSprints = sprintService.findActiveSprintsForUser( loggedInUser.getCompanyId(), userId, token );
		model.addAttribute( "activeSprints", activeSprints );

		Map<String, List<ScrumTeamResponseDto>> scrumTeams = scrumMasterService.findAllScrumTeamsForUser( loggedInUser.getCompanyId(), userId, token );
		model.addAttribute( "scrumTeams", scrumTeams );

		int projectCount = projectService.countAllprojectByCompany( loggedInUser.getCompanyId(), token );
		model.addAttribute( "projectCount", projectCount );

		int taskCount = taskService.countAllTasksByCompany( loggedInUser.getCompanyId(), token );
		model.addAttribute( "taskCount", taskCount );

		int userCount = userService.countAllUsersByCompany( loggedInUser.getCompanyId(), token );
		model.addAttribute( "userCount", userCount );

		int userStoriesCount = userStoryService.countAllStoryByCompany( loggedInUser.getCompanyId(), token );
		model.addAttribute( "userStoriesCount", userStoriesCount );

		model.addAttribute( "projectListByUser", projectListByUser );
		model.addAttribute( "taskList", taskList );

		model.addAttribute( Constants.PAGE_TITLE, "Dashboard" );

		return "dashboards/companyAdminDashboard";
	}

	@ResponseBody
	@GetMapping( "/user/task-count/{projectId}" )
	public Map<String, Integer> findTaskCountForUser( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( "loggedInUser" );
		String token = ( String ) session.getAttribute( "token" );
		Long selectedUserId = ( Long ) session.getAttribute( "userId" );
		if ( selectedUserId == null ) {
			selectedUserId = loggedInUser.getId();
		}
		return scrumMasterService.findTaskCountForUser( loggedInUser.getCompanyId(), projectId, selectedUserId, token );
	}

	@ResponseBody
	@GetMapping( "/user/story-point-count/{projectId}" )
	public Map<String, Integer> findStoryPointCountForUser( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( "loggedInUser" );
		String token = ( String ) session.getAttribute( "token" );
		Long selectedUserId = ( Long ) session.getAttribute( "userId" );
		if ( selectedUserId == null ) {
			selectedUserId = loggedInUser.getId();
		}
		return scrumMasterService.findStoryPointCountForUser( loggedInUser.getCompanyId(), projectId, selectedUserId, token );
	}

	@ResponseBody
	@GetMapping( "/top-five-tasks/{projectId}" )
	public List<TaskDto> findAllTasksByUser( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( "loggedInUser" );
		String token = ( String ) session.getAttribute( "token" );
		Long selectedUserId = ( Long ) session.getAttribute( "userId" );
		if ( selectedUserId == null ) {
			selectedUserId = loggedInUser.getId();
		}
		return taskService.getTop5TasksByUser( token, selectedUserId, projectId,
				loggedInUser.getCompanyId() );
	}

	@GetMapping( "/getAllTaskByUser" )
	public String getAllTasksByLoginUser( HttpSession session, Model model, @RequestParam int pageNo ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( "defaultProjectId" );
		String token = ( String ) session.getAttribute( "token" );
		model.addAttribute( "projectList", projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( "notifications", notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( "token" ) ) );
		TaskPagerDto list = taskService.getAllTasksByUser( token, loggedInUser.getId(), defaultProjectId, loggedInUser.getCompanyId(), pageNo );
		model.addAttribute( "taskList", list );

		return "tasks/allTask";

	}

	@GetMapping( "/getAllProjectByUser" )
	public String getAllProjectsByLoginUser( HttpSession session, Model model, @RequestParam int pageNo ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		ProjectPagerDto pagerDto = projectService.getAllProjectsByUser( token, loggedInUser.getId(),
				loggedInUser.getCompanyId(), pageNo );

		List<ProjectResponseDto> list2 = new ArrayList<>();
		for ( Content content : pagerDto.getContent() ) {
			Long id = content.getId();
			ProjectResponseDto project1 = projectService.findById( id, token );
			list2.add( project1 );
		}

		ProjectResDto dto = new ProjectResDto( list2, pagerDto.getPageable(), pagerDto.isLast(),
				pagerDto.getTotalPages(), pagerDto.getTotalElements(), pagerDto.getSize(), pagerDto.getNumber(),
				pagerDto.getNumberOfElements(), pagerDto.getSort(), pagerDto.isFirst(), pagerDto.isEmpty() );
		model.addAttribute( "project", dto );

		return "projects/allproject";
	}

	@GetMapping( "/stories/{projectId}/{sprintId}" )
	public String allStoriesBy( @PathVariable Long projectId, @PathVariable int sprintId, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), projectId );
		try {
			Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), projectId, sprintId );
			int storyPointsPerSprint = sprintUtility.storyPointPerSprint( map, projectId, loggedInUser.getCompanyId(), token );
			int completedStoryPointsPerSprint = sprintUtility.completedStoryPointsPerSprint( map, projectId, loggedInUser.getCompanyId(), token );
			model.addAttribute( Constants.COMPLETED_STORY_POINT_PER_SPRINT, completedStoryPointsPerSprint );
			model.addAttribute( Constants.TOTAL_STORY_POINTS, storyPointsPerSprint );
			model.addAttribute( "data", map );
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		int remianingDays = sprintUtility.calculateSprintRemainingDays( dto );
		model.addAttribute( Constants.REMAINING_SPRINT_DAYS, remianingDays );
		model.addAttribute( "sprint", dto );
		model.addAttribute( Constants.SPRINT_NAME, dto.getName() );
		model.addAttribute( Constants.SPRINT_ID, dto.getId() );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return "dashboards/tasksPerSprint";
	}

}
