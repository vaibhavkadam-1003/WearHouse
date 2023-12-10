package com.pluck.controller;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.project.ProjectUserRequestDto;
import com.pluck.dto.scrum.ScrumRequestDto;
import com.pluck.dto.scrum.ScrumTeamDetailsDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.scrum.SprintScrumTeamDetails;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.LoginService;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectService;
import com.pluck.service.ScrumTeamService;
import com.pluck.service.UserService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping( "/scrums" )
@Slf4j
public class ScrumTeamController {

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private ProjectService projectService;

	@Autowired
	private ScrumTeamService scrumTeamService;

	@Autowired
	private UserService userService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private LoginService loginService;

	@GetMapping( "/addScrumForm" )
	public String addScrumForm( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		model.addAttribute( Constants.USER_LIST_BY_PROJECT, list );
		List<ProjectDropdownResponseDto> assignedProjects = projectUtilities.getProjectDropdown( session, false );
		model.addAttribute( "projectManagersProjects", assignedProjects );
		model.addAttribute( Constants.PROJECT_LIST, assignedProjects );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "scrum/addScrum";
	}

	@ResponseBody
	@GetMapping( "/scrum-masters-for-project/{projectId}" )
	public List<UserResponseDTO> scrumMastersForProject( @PathVariable Long projectId, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumTeamService.findAllScrumMastersForProject( loggedInUser.getCompanyId(), projectId, token );

	}

	@ResponseBody
	@PostMapping( "/addScrum" )
	public String addScrum( @RequestBody ScrumRequestDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		return scrumTeamService.add( dto, token );
	}

	@ResponseBody
	@PostMapping( "/addUser/{id}" )
	public String addScrumUser( @PathVariable Long id, @RequestBody ProjectUserRequestDto dto, Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumTeamService.addUsers( id, dto, loggedInUser.getCompanyId(), defaultProjectId, token );

	}

	@ResponseBody
	@PostMapping( "/addUser/{id}/{projectId}" )
	public String addScrumUserFromDashboard( @PathVariable Long id, @PathVariable Long projectId, @RequestBody ProjectUserRequestDto dto, Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		//Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumTeamService.addUsers( id, dto, loggedInUser.getCompanyId(), projectId, token );

	}

	@GetMapping
	public String allScrumTeam( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<ScrumTeamResponseDto> list = scrumTeamService.allScrumTeams( loggedInUser.getCompanyId(), defaultProjectId, token );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		model.addAttribute( "teams", list );
		return "scrum/allScrumTeams";
	}

	@GetMapping( "/all-teams-by-active-sprint/{projectId}" )
	public String allScrumTeamsByActiveSprint( Model model, HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<ScrumTeamResponseDto> list = scrumTeamService.allScrumTeamsByActiveSprint( loggedInUser.getCompanyId(), projectId, token );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		model.addAttribute( "teams", list );
		return "scrum/allScrumTeams";
	}

	@GetMapping( "/details/{id}" )
	public String scrumById( Model model, HttpSession session, @PathVariable Long id ) {
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		model.addAttribute( Constants.USER_LIST_BY_PROJECT, list );
		model.addAttribute( Constants.ALL_USER_COUNT, list.size() );
		ScrumTeamDetailsDto dto = scrumTeamService.findByScrumId( loggedInUser.getCompanyId(), id, token );
		model.addAttribute( "team", dto );
		model.addAttribute( Constants.ADDED_SCRUM_USER_COUNT, dto.getUsers().size() );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "scrum/scrumDetails";
	}

	@GetMapping( "/details/{id}/{projectId}" )
	public String scrumById1( Model model, HttpSession session, @PathVariable Long id, @PathVariable Long projectId ) {
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		//Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Set<UserResponseDTO> list = projectService.allUsersByProject( projectId, loggedInUser.getCompanyId(), token, 0 );
		model.addAttribute( Constants.USER_LIST_BY_PROJECT, list );
		ScrumTeamDetailsDto dto = scrumTeamService.findByScrumId( loggedInUser.getCompanyId(), id, token );
		model.addAttribute( "projectId", projectId );
		model.addAttribute( "team", dto );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "dashboards/dashboardScrumDetails";
	}

	@GetMapping( "/delete/{teamId}/{userId}" )
	public String deleteUserFromScrumTeam( @PathVariable Long teamId, @PathVariable Long userId, HttpSession session, RedirectAttributes ra, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String message = scrumTeamService.deleteUserFromScrumTeam( teamId, userId, loggedInUser.getCompanyId(), defaultProjectId, token );

		if ( Constants.DELETE_SCRUM_USER.equals( message ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, message );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, message );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "redirect:/scrums/details/" + teamId;
	}

	@GetMapping( "/delete/{teamId}/{userId}/{projectId}" )
	public String deleteUserFromScrumTeamForDashboard( @PathVariable Long teamId, @PathVariable Long projectId, @PathVariable Long userId, HttpSession session, RedirectAttributes ra, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		//Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String message = scrumTeamService.deleteUserFromScrumTeam( teamId, userId, loggedInUser.getCompanyId(), projectId, token );

		if ( Constants.DELETE_SCRUM_USER.equals( message ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, message );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, message );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "redirect:/scrums/details/" + teamId + "/" + projectId;
	}

	@GetMapping( "/tasks/{scrumId}/{userId}" )
	public String tasksByUserId( @PathVariable Long scrumId, @PathVariable Long userId, HttpSession session, Model model ) {
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		model.addAttribute( Constants.USER_LIST_BY_PROJECT, list );

		ScrumTeamDetailsDto dto = scrumTeamService.findByScrumId( loggedInUser.getCompanyId(), scrumId, token );
		model.addAttribute( "team", dto );
		try {
			UserResponseDTO userDto = userService.findByid( userId, token );
			model.addAttribute( "userDetails", userDto );
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		List<TaskDto> tasks = scrumTeamService.findTasksByProjectIdAndUserId( loggedInUser.getCompanyId(), defaultProjectId, userId, token );
		model.addAttribute( "taskList", tasks );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "scrum/scrumDetails";
	}

	@GetMapping( "/scrumTeam" )
	public String scrumTeam( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		model.addAttribute( Constants.USER_LIST_BY_PROJECT, list );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "scrum/scrumTeam";
	}

	@GetMapping( "/scrumTeamDetails" )
	public String scrumTeamDetails( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		model.addAttribute( Constants.USER_LIST_BY_PROJECT, list );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "scrum/detailsScrumTeam";
	}

	@ResponseBody
	@GetMapping( "/sprint/history/scrum/members" )
	public List<SprintScrumTeamDetails> scrumTeamDetailsForSprint( @RequestParam Long scrumId, @RequestParam Integer sprintId, Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumTeamService.scrumTeamDetailsForSprint( loggedInUser.getCompanyId(), scrumId, sprintId, token );
	}

	@ResponseBody
	@GetMapping( "/sprint/history/scrum" )
	public String scrumTeamName( @RequestParam Long scrumId, HttpSession session, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return scrumTeamService.scrumTeamName( scrumId, token );
	}

	@ResponseBody
	@GetMapping( "/users-by-project/{projectId}" )
	public Set<UserResponseDTO> getAllUsersByProject( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Set<UserResponseDTO> users = projectService.allUsersByProject( projectId, loggedInUser.getCompanyId(), token, 0 );
		for ( UserResponseDTO dto : users ) {
			String highestRole = loginService.getHighestRole( dto.getRole() );
			dto.setHighestRole( highestRole );
		}
		return users;
	}
	
	@ResponseBody
	@GetMapping("/delete/{teamId}")
	public String deleteScrumTeam(@PathVariable Long teamId, HttpSession session) {
		String token = (String) session.getAttribute(Constants.TOKEN);
		return  scrumTeamService.deleteTeam(teamId, token);	
	}
	
	@ResponseBody
	@PostMapping( "/update" )
	public ScrumTeamDetailsDto updateScrumTeam( @ModelAttribute ScrumRequestDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		return scrumTeamService.updateTeam( dto, token );
	}

}
