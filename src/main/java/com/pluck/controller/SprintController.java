package com.pluck.controller;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.constants.ViewConstants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.scrum.ScrumTeamDetailsDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.sprint.CloseSprintDto;
import com.pluck.dto.sprint.SprintHistoryResponseDto;
import com.pluck.dto.sprint.SprintHistoryTaskDto;
import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.sprint.StartSprintRequestDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ScrumTeamService;
import com.pluck.service.SprintService;
import com.pluck.service.TaskService;
import com.pluck.utilites.Cookies;
import com.pluck.utilites.ProjectUtilities;
import com.pluck.utilites.SprintUtility;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping( "/sprints" )
@Slf4j
public class SprintController {

	@Autowired
	private SprintService service;

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private SprintService sprintService;

	@Autowired
	private TaskService taskService;

	@Autowired
	private ScrumTeamService scrumTeamService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private SprintUtility sprintUtility;

	@Autowired
	private Cookies cookies;

	@GetMapping( "/addSprintForm" )
	public String addSprintForm( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		List<TaskDto> tasks = taskService.getAllIncompleteTasksToStartSprint( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( "tasks", tasks );
		List<ScrumTeamResponseDto> scrumTeams = scrumTeamService.allScrumTeams( loggedInUser.getCompanyId(), defaultProjectId, token );
		List<ScrumTeamDetailsDto> scrumDetailsList = scrumTeamService.getScrumDetails( scrumTeams, loggedInUser.getCompanyId(), token );
		model.addAttribute( "scrumteams", scrumDetailsList );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return ViewConstants.ADD_SPRINT;
	}

	@PostMapping
	public String addSprint( @ModelAttribute SprintDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_SPRINT );
			return ViewConstants.ADD_SPRINT;
		}
		String addStatus = service.addSprint( dto, token, loggedInUser, defaultProjectId );
		if ( Constants.ADD_SPRINT_SUCCESS.equals( addStatus ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, addStatus );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, addStatus );

		return ViewConstants.REDIRECT_TO_ALL_TASK;
	}

	@ResponseBody
	@GetMapping( "/current-sprint-status/{sprintId}" )
	public Map<String, Integer> currentSprintStatus( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		SprintDto dto = sprintService.findById( sprintId, token );
		Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, sprintId );

		List<ScrumTeamResponseDto> teams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), sprintId, token );

		int storyPointsPerSprint = sprintUtility.storyPointPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
		int completedStoryPointsPerSprint = sprintUtility.completedStoryPointsPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
		int remianingDays = sprintUtility.calculateSprintRemainingDays( dto );

		return sprintUtility.generateStatus( map, storyPointsPerSprint, completedStoryPointsPerSprint, remianingDays, teams );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-status/id/{id}/project/{projectId}" )
	public Map<String, Integer> currentSprintStatusBySprintId( @PathVariable int id, @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), projectId );
		Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), projectId, id );

		List<ScrumTeamResponseDto> teams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), id, token );

		int storyPointsPerSprint = sprintUtility.storyPointPerSprint( map, projectId, loggedInUser.getCompanyId(), token );
		int completedStoryPointsPerSprint = sprintUtility.completedStoryPointsPerSprint( map, projectId, loggedInUser.getCompanyId(), token );
		int remianingDays = sprintUtility.calculateSprintRemainingDays( dto );

		return sprintUtility.generateStatus( map, storyPointsPerSprint, completedStoryPointsPerSprint, remianingDays, teams );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-user-chart-details/id/{id}/project/{projectId}" )
	public List<SprintUserChartDetailsDto> currentSprintUserChartDetailsBySprintId( @PathVariable int id, @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.findCurrentSprintUserChartDetails( loggedInUser.getCompanyId(), projectId, id, token );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-user-chart-details/{sprintId}" )
	public List<SprintUserChartDetailsDto> currentSprintUserChartDetails( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		return sprintService.findCurrentSprintUserChartDetails( loggedInUser.getCompanyId(), defaultProjectId, sprintId, token );
	}

	@ResponseBody
	@GetMapping( "/sprint-history-user-chart-details" )
	public List<SprintUserChartDetailsDto> sprintHistoryserChartDetails( @RequestParam Integer sprintId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.findSprintHistoryUserChartDetails( loggedInUser.getCompanyId(), defaultProjectId, sprintId, token );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-scrum-teams/{sprintId}" )
	public List<ScrumTeamResponseDto> currentSprintScrumTeams( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		return sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), sprintId, token );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-scrum-teams/id/{id}" )
	public List<ScrumTeamResponseDto> currentSprintScrumTeamsBySprintId( @PathVariable int id, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), id, token );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-tasks/id/{id}/project/{projectId}" )
	public List<TaskDto> currentSprintAllTasks( @PathVariable int id, @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.currentSprintAllTasks( loggedInUser.getCompanyId(), projectId, id, token );
	}

	@ResponseBody
	@GetMapping( "/current-sprint-tasks/{sprintId}" )
	public List<TaskDto> currentSprintAllTasks( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		return sprintService.currentSprintAllTasks( loggedInUser.getCompanyId(), defaultProjectId, sprintId, token );
	}

	@ResponseBody
	@GetMapping( "/tasks/{sprintId}" )
	public Map<String, Object> tasksBySprintId( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Map<String, Object> data = new HashMap<String, Object>();
		List<SprintDto> availableSprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		data.put( "nextSprints", availableSprints );
		data.put( "tasks", sprintService.currentSprintAllTasks( loggedInUser.getCompanyId(), defaultProjectId, sprintId, token ) );

		return data;
	}

	@ResponseBody
	@GetMapping( "/previous-sprint-tasks/{sprintId}" )
	public List<SprintHistoryTaskDto> sprintAllTasksHistory( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		return sprintService.sprintAllTasksHistory( loggedInUser.getCompanyId(), defaultProjectId, sprintId, token );
	}

	@GetMapping( "/stories" )
	public String allStories( Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );

		if ( currentSprint == null ) {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.NO_SPRINT_MESSAGE );

			return ViewConstants.REDIRECT_TO_ALL_TASK;
		}
		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), defaultProjectId );
		Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, currentSprint );

		int storyPointsPerSprint = sprintUtility.storyPointPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
		int completedStoryPointsPerSprint = sprintUtility.completedStoryPointsPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
		int remianingDays = sprintUtility.calculateSprintRemainingDays( dto );

		model.addAttribute( Constants.COMPLETED_STORY_POINT_PER_SPRINT, completedStoryPointsPerSprint );
		model.addAttribute( Constants.REMAINING_SPRINT_DAYS, remianingDays );
		model.addAttribute( Constants.TOTAL_STORY_POINTS, storyPointsPerSprint );
		model.addAttribute( "data", map );
		model.addAttribute( Constants.SPRINT_NAME, dto.getName() );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return ViewConstants.TASKS_PER_SPRINT;
	}

	@GetMapping( "/active-sprint-history/{id}" )
	public String activeSprints( @ModelAttribute SprintDto dto, Model model, HttpSession session, RedirectAttributes ra, @PathVariable Integer id ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		SprintDto dto1 = sprintService.findCurrentActiveSprint( token, loggedInUser.getCompanyId(), defaultProjectId, id );
		try {
			Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, id );
			int storyPointsPerSprint = sprintUtility.storyPointPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
			int completedStoryPointsPerSprint = sprintUtility.completedStoryPointsPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
			model.addAttribute( Constants.COMPLETED_STORY_POINT_PER_SPRINT, completedStoryPointsPerSprint );
			model.addAttribute( Constants.TOTAL_STORY_POINTS, storyPointsPerSprint );
			model.addAttribute( "data", map );
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		int remianingDays = sprintUtility.calculateSprintRemainingDays( dto1 );

		model.addAttribute( Constants.REMAINING_SPRINT_DAYS, remianingDays );
		model.addAttribute( "sprint", dto1 );
		model.addAttribute( Constants.SPRINT_NAME, dto1.getName() );
		model.addAttribute( Constants.SPRINT_ID, dto1.getId() );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PAGE_TITLE, "Active Sprint" );
		return ViewConstants.TASKS_PER_SPRINT;
	}

	@GetMapping( "/stories2" )
	public String allStories1( Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );
		if ( currentSprint == null ) {
			model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
					loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
			model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.NO_SPRINT_MESSAGE );
			return ViewConstants.NO_SPRINT;
		}
		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), defaultProjectId );
		try {
			Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), defaultProjectId, currentSprint );
			int storyPointsPerSprint = sprintUtility.storyPointPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
			int completedStoryPointsPerSprint = sprintUtility.completedStoryPointsPerSprint( map, defaultProjectId, loggedInUser.getCompanyId(), token );
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
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PAGE_TITLE, "Active Sprint" );
		return ViewConstants.TASKS_PER_SPRINT;
	}

	@GetMapping( "/stories2/{projectId}" )
	public String allStories2( @PathVariable Long projectId, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );
		if ( currentSprint == null ) {
			model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
					loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
			model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.NO_SPRINT_MESSAGE );
			return ViewConstants.NO_SPRINT;
		}
		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), projectId );
		try {
			Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), projectId, currentSprint );
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
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.TASKS_PER_SPRINT;
	}

	@GetMapping( "/stories/{projectId}" )
	public String allStoriesBy( @PathVariable Long projectId, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );
		if ( currentSprint == null ) {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.NO_SPRINT_MESSAGE );
			return ViewConstants.REDIRECT_TO_ALL_TASK;
		}
		SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), projectId );
		try {
			Map<String, List<TaskDto>> map = sprintService.findTasksBySprint( token, loggedInUser.getCompanyId(), projectId, currentSprint );
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
		return ViewConstants.TASKS_PER_SPRINT;
	}

	@GetMapping( "/start-sprint-form" )
	public String startSprintForm( Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_SPRINT );
			return "projects/allproject";
		}

		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( sprints.isEmpty() ) {
			model.addAttribute( "NosprintMessage", "No sprint available to start" );
			return ViewConstants.ADD_SPRINT;
		}
		model.addAttribute( "sprints", sprints );

		List<ScrumTeamResponseDto> scrumTeams = scrumTeamService.allScrumTeams( loggedInUser.getCompanyId(), defaultProjectId, token );
		List<ScrumTeamDetailsDto> scrumDetailsList = scrumTeamService.getScrumDetails( scrumTeams, loggedInUser.getCompanyId(), token );
		model.addAttribute( "scrumteams", scrumDetailsList );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return "sprints/startSprint";
	}

	@GetMapping( "/add-scrum-to-sprint-form1/id/{id}/project/{projectId}" )
	public String startScrumToSprintFormDashboard( @PathVariable int id, @PathVariable Long projectId, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<ScrumTeamResponseDto> scrumTeams = scrumTeamService.allScrumTeams( loggedInUser.getCompanyId(), projectId, token );
		List<ScrumTeamResponseDto> alreadyExistedTeams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), id, token );
		List<ScrumTeamResponseDto> list = sprintUtility.findNewScrumTeams( scrumTeams, alreadyExistedTeams );
		List<ScrumTeamDetailsDto> scrumDetailsList = scrumTeamService.getScrumDetails( list, loggedInUser.getCompanyId(), token );
		if ( scrumDetailsList.isEmpty() ) {
			model.addAttribute( "scrumTeamMessage", "No team is available to add" );
			model.addAttribute( "projectId", projectId );
			return "sprints/addScrumToSprint1";
		}
		model.addAttribute( "sprintId", id );
		model.addAttribute( "projectId", projectId );
		model.addAttribute( "scrumteams", scrumDetailsList );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return "sprints/addScrumToSprint1";
	}

	@GetMapping( "/add-scrum-to-sprint-form" )
	public String startScrumToSprintForm( Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );
		List<ScrumTeamResponseDto> scrumTeams = scrumTeamService.allScrumTeams( loggedInUser.getCompanyId(), defaultProjectId, token );
		List<ScrumTeamResponseDto> alreadyExistedTeams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), currentSprint, token );
		List<ScrumTeamResponseDto> list = sprintUtility.findNewScrumTeams( scrumTeams, alreadyExistedTeams );
		List<ScrumTeamDetailsDto> scrumDetailsList = scrumTeamService.getScrumDetails( list, loggedInUser.getCompanyId(), token );
		if ( scrumDetailsList.isEmpty() ) {
			model.addAttribute( "scrumTeamMessage", "No team is available to add" );
			return "sprints/addScrumToSprint";
		}
		model.addAttribute( "scrumteams", scrumDetailsList );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return "sprints/addScrumToSprint";
	}

	@PostMapping( "/add-scrum-to-sprint" )
	public String addScrumToSprint( HttpServletResponse response, @ModelAttribute StartSprintRequestDto dto, HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );
		dto.setSprintId( currentSprint );
		String status = sprintService.addScrumToSprint( token, dto );
		if ( status.equals( "Unable to add scrum to sprint" ) ) {
			model.addAttribute( Constants.ERROR_MESSAGE, status );
			return null;
		}
		session.setAttribute( Constants.CURRENT_SPRINT, dto.getSprintId() );
		cookies.setCookie( response, Constants.CURRENT_SPRINT, session.getAttribute( Constants.CURRENT_SPRINT ) == null ? null : session.getAttribute( Constants.CURRENT_SPRINT ).toString() );

		ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, status );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return ViewConstants.REDIRECT_TO_STORIES_2;
	}

	@PostMapping( "/add-scrum-to-sprint-1" )
	public String addScrumToSprintById( @ModelAttribute StartSprintRequestDto dto, HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		String status = sprintService.addScrumToSprint( token, dto );
		if ( status.equals( "Unable to add scrum to sprint" ) ) {
			model.addAttribute( Constants.ERROR_MESSAGE, status );
			return null;
		}
		session.setAttribute( Constants.CURRENT_SPRINT, dto.getSprintId() );
		ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, status );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return "redirect:/dashboard/stories/" + dto.getProjectId() + "/" + dto.getSprintId();
	}

	@PostMapping( "/start" )
	public String startSprint( HttpServletResponse response, @ModelAttribute StartSprintRequestDto dto, HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		Long sprint = sprintService.countByAndScrumIdAndStatus( dto.getScrumTeams(), token );
		if ( sprint == null ) {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, "Please Select Scrum  Team First." );
			return ViewConstants.REDIRECT_TO_START_SPRINT_FORM;
		}

		if ( sprint.longValue() != 0 ) {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, "You Already Have An Active Sprint Of Similar Scrum Team." );
			return ViewConstants.REDIRECT_TO_START_SPRINT_FORM;
		}

		String status = sprintService.startSprint( token, dto );

		String regex = "started";

		Pattern pattern = Pattern.compile( regex );
		Matcher matcher = pattern.matcher( status );

		if ( matcher.find() )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, status );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, status );

		session.setAttribute( Constants.CURRENT_SPRINT, dto.getSprintId() );
		cookies.setCookie( response, Constants.CURRENT_SPRINT, String.valueOf( dto.getSprintId() ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return ViewConstants.REDIRECT_TO_ACTIVE_SPRINTS;
	}

	@ResponseBody
	@GetMapping( "/available" )
	public List<SprintDto> availableSprints( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Integer currentSprint = ( Integer ) session.getAttribute( Constants.CURRENT_SPRINT );
		if ( currentSprint != null ) {
			return Collections.emptyList();
		}
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return sprints;
	}

	@ResponseBody
	@GetMapping( "/close-sprint-info/{sprintId}" )
	public Map<String, Integer> closeSprintInfo( HttpSession session, Model model, @PathVariable Integer sprintId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		Map<String, Integer> data = sprintService.findSprintInfo( token, loggedInUser.getCompanyId(), defaultProjectId, sprintId );
		List<ScrumTeamResponseDto> teams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), sprintId, token );
		if ( teams != null )
			data.put( "teams", teams.size() );
		else
			data.put( "teams", 0 );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(), loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return data;
	}

	@ResponseBody
	@GetMapping( "/close-sprint-info/id/{id}/{project}/{projectId}" )
	public Map<String, Integer> closeSprintInfoBySprintId( @PathVariable int id, @PathVariable Long projectId, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Map<String, Integer> data = sprintService.findSprintInfo( token, loggedInUser.getCompanyId(), projectId, id );
		List<ScrumTeamResponseDto> teams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), id, token );
		if ( teams != null )
			data.put( "teams", teams.size() );
		else
			data.put( "teams", 0 );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(), loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return data;
	}

	@PostMapping( "/close-sprint" )
	public String closeSprint( HttpSession session, Model model, RedirectAttributes ra, @ModelAttribute CloseSprintDto dto, HttpServletResponse response ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		String status = sprintService.closeSprint( token, loggedInUser.getCompanyId(), defaultProjectId, dto.getSprintId(), dto );
		ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, status );
		session.setAttribute( Constants.CURRENT_SPRINT, null );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return ViewConstants.REDIRECT_TO_ALL_TASK;
	}

	@ResponseBody
	@GetMapping( "/tasks" )
	public TaskDto addTaskToSprint( @RequestParam Long taskId, @RequestParam Long sprintId, Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		int sprint = sprintId.intValue();
		TaskDto dto = sprintService.addTaskToSprint( token, taskId, sprint );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return dto;
	}

	@GetMapping( "/previous" )
	public String previousSprints( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		List<SprintDto> previuosSprints = sprintService.findPreviousSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( previuosSprints.isEmpty() ) {
			model.addAttribute( "previousSprints", previuosSprints );
			model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
					loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
			model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
			model.addAttribute( Constants.PAGE_TITLE, "No Sprint Closed" );
			return ViewConstants.NO_SPRINT_ACTIVE;
		}
		model.addAttribute( Constants.PAGE_TITLE, "Previous Sprints" );

		model.addAttribute( "previousSprints", previuosSprints );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.PAGE_TITLE, "Previous Sprints" );

		return "sprints/previousSprints";
	}

	@GetMapping( "/activeSprints" )
	public String activeSprints( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		List<SprintDto> activeSprints = sprintService.findActiveSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( activeSprints.isEmpty() ) {
			model.addAttribute( "activeSprints", activeSprints );
			model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
					loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
			model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
			model.addAttribute( Constants.PAGE_TITLE, "No Sprint Closed" );
			return ViewConstants.NO_SPRINT_ACTIVE;
		}
		model.addAttribute( Constants.PAGE_TITLE, "Active Sprints" );

		model.addAttribute( "activeSprints", activeSprints );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.PAGE_TITLE, "Active Sprints" );

		return "sprints/activeSprints";
	}

	@GetMapping( "/sprint-history/{id}" )
	public String sprintHistory( Model model, HttpSession session, @PathVariable Integer id ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		List<SprintHistoryResponseDto> list = sprintService.findHistoryById( token, defaultProjectId, id );
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
		List<ScrumTeamResponseDto> teams = sprintService.findScrumTeamForSprint( loggedInUser.getCompanyId(), id, token );
		model.addAttribute( "totalTasks", totalTasks );
		model.addAttribute( "completedTasks", completedTasks );
		model.addAttribute( "incompletedTasks", incompletedTasks );
		model.addAttribute( Constants.TOTAL_STORY_POINTS, totalStoryPoints );
		model.addAttribute( "completedStoryPoints", completedStoryPoints );
		model.addAttribute( "incompletedStoryPoints", incompleteStoryPoints );
		model.addAttribute( Constants.SPRINT_ID, id );
		model.addAttribute( "teams", teams );
		model.addAttribute( "sprintId", id );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "sprints/sprintHistory";
	}

	@ResponseBody
	@GetMapping( "/current-project-user-chart-details" )
	public List<SprintUserChartDetailsDto> currentProjectUserChartDetails( HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.findCurrentProjectUserChartDetails( loggedInUser.getCompanyId(), defaultProjectId, token );
	}

	@ResponseBody
	@GetMapping( "/history/sprint-name" )
	public String sprintNameForSprintHistory( @RequestParam int sprintId, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.findName( sprintId, token );
	}

	@GetMapping( "/tasks/history" )
	public String tasksHistory( @RequestParam Integer sprintId, @RequestParam String status, HttpSession session, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<TaskDto> list = sprintService.findSprintTasks( sprintId, status, token );
		model.addAttribute( "tasks", list );
		model.addAttribute( Constants.SPRINT_ID, sprintId );
		return "sprints/taskHistory";
	}

	@ResponseBody
	@GetMapping( "/tasks/filter/{sprintId}" )
	public List<TaskDto> currentSprintTaskFilter( @RequestParam String status, @PathVariable int sprintId, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.currentSprintTaskFilter( sprintId, status, token );
	}

	@ResponseBody
	@GetMapping( "/tasks/filter/id/{id}" )
	public List<TaskDto> currentSprintTaskFilterBySprintId( @PathVariable int id, @RequestParam String status, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.currentSprintTaskFilter( id, status, token );
	}

	@ResponseBody
	@GetMapping( "/history/tasks/filter" )
	public List<TaskDto> sprintHistoryTaskFilter( @RequestParam Integer sprintId, @RequestParam String status, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return sprintService.sprintHistoryTaskFilter( sprintId, status, token );
	}

}
