package com.pluck.controller;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.constants.ViewConstants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.project.Content;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.project.ProjectPagerDto;
import com.pluck.dto.project.ProjectRequestDto;
import com.pluck.dto.project.ProjectResDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.project.ProjectUserRequestDto;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.user.UserDropdownResponseDto;
import com.pluck.service.LoginService;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectService;
import com.pluck.service.ScrumMasterService;
import com.pluck.service.SprintService;
import com.pluck.utilites.Cookies;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequestMapping( "/projects" )
@Controller
@AllArgsConstructor
@Slf4j
public class ProjectController {
	private final ProjectService projectService;

	private final ProjectUtilities projectUtilities;

	private final SprintService sprintService;

	private final NotificationService notificationService;

	private final DropdownCache dropdownCache;

	private final LoginService loginService;

	private final ScrumMasterService scrumMasterService;

	private final Cookies cookies;

	@GetMapping( "/add/form" )
	public String getUserForm( Model model, HttpSession session ) {

		String token = ( String ) session.getAttribute( Constants.TOKEN );

		List<UserDropdownResponseDto> list = projectService.getUsersDropdown( token );
		model.addAttribute( "lists", list );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );

		return "projects/add";
	}

	@PostMapping( "/addProject" )
	public String addProject( HttpServletResponse response, @ModelAttribute ProjectRequestDto projectRequestDto, Model model, HttpSession session, RedirectAttributes ra ) throws URISyntaxException {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		int count = projectService.countByCompanyIdAndName( loggedInUser.getCompanyId(), projectRequestDto.getName(), token );
		if ( count > 0 ) {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.PROJECT_ALREADY_EXISTS );
		} else {
			ProjectResponseDto addedProject = projectService.addProject( projectRequestDto, loggedInUser, token );
			if ( addedProject != null ) {
				dropdownCache.loadStoryPoints( loggedInUser.getCompanyId(), token );
				dropdownCache.loadPriorites( loggedInUser.getCompanyId(), token );
				dropdownCache.loadSeverities( loggedInUser.getCompanyId(), token );
				dropdownCache.loadStatus( loggedInUser.getCompanyId(), token );
				ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.ADD_PROJECT_SUCCESS );
				Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
				if ( defaultProjectId == null ) {
					boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( projectRequestDto, loggedInUser.getId() );
					if ( isLoggedInUserPresent ) {
						session.setAttribute( Constants.DEFAULT_PROJECT_ID, addedProject.getId() );
						session.setAttribute( Constants.DEFAULT_PROJECT_NAME, addedProject.getName() );
						cookies.setDefaultProject( response, addedProject.getId(), addedProject.getName() );
					}
				}
			} else {
				ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.ADD_PROJECT_ERROR );
			}
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		return "redirect:/projects/allproject?pageNo=0";

	}

	@GetMapping( "/allproject" )
	public String findAllProject( Model model, HttpSession session, @ModelAttribute( Constants.MESSAGE ) String message, @RequestParam int pageNo ) throws URISyntaxException {
		ProjectPagerDto pager = projectService.findAll( ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER ), ( String ) session.getAttribute( Constants.TOKEN ), pageNo );
		model.addAttribute( "list", pager );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		List<ProjectResponseDto> list2 = new ArrayList<>();
		for ( Content content : pager.getContent() ) {
			Long id = content.getId();
			ProjectResponseDto project1 = projectService.findById( id, ( String ) session.getAttribute( Constants.TOKEN ) );
			list2.add( project1 );
		}
		ProjectResDto dto = new ProjectResDto( list2, pager.getPageable(), pager.isLast(), pager.getTotalPages(), pager.getTotalElements(), pager.getSize(), pager.getNumber(), pager.getNumberOfElements(), pager.getSort(), pager.isFirst(), pager.isEmpty() );
		if ( !loggedInUser.getRole().contains( "Company Admin" ) ) {
			List<ProjectResponseDto> projectList = dto.getContent().stream().filter( project -> project.getOwners().stream().filter( owner -> owner.getId().equals( loggedInUser.getId() ) ).count() != 0 || project.getUsers().stream().filter( user -> user.getId().equals( loggedInUser.getId() ) ).count() != 0 ).toList();
			projectList.forEach( project -> project.setEditAcces( project.getOwners().stream().filter( owner -> owner.getId().equals( loggedInUser.getId() ) ).count() != 0 ) );
			dto.setContent( projectList );
		}
		model.addAttribute( Constants.PROJECT, dto );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "projects/allproject";
	}

	@GetMapping( "/update/form/{id}" )
	public String updateProject( @PathVariable( value = "id" ) long id, Model model, HttpSession session ) {

		ProjectResponseDto project = projectService.findById( id, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );

		List<UserDropdownResponseDto> list = projectService.getUsersDropdown( ( String ) session.getAttribute( Constants.TOKEN ) );

		Set<UserDropdownResponseDto> availableOwners = projectUtilities.generateOwnersList( project, list );
		Set<UserDropdownResponseDto> availableUsers = projectUtilities.generateUsersList( project, list );
		model.addAttribute( Constants.OWNER_LIST, availableOwners );
		model.addAttribute( Constants.USER_LIST, availableUsers );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return ViewConstants.UPDATE_PROJECT;
	}

	@GetMapping( "/default" )
	public String defaultProject( Long project, HttpSession session, Model model, HttpServletResponse response ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		ProjectResponseDto existingProject = projectService.findById( project, ( String ) session.getAttribute( Constants.TOKEN ) );

		session.setAttribute( Constants.DEFAULT_PROJECT_ID, project );
		session.setAttribute( Constants.DEFAULT_PROJECT_NAME, existingProject.getName() );

		cookies.setDefaultProject( response, project, existingProject.getName() );
		cookies.setCookie( response, Constants.CURRENT_SPRINT, session.getAttribute( Constants.CURRENT_SPRINT ) == null ? null : session.getAttribute( Constants.CURRENT_SPRINT ).toString() );
		LoginUserDto loggedInuser = loginService.getLoggedInUser( token, project );
		String newToken = loginService.getDefaultProjectToken( loggedInUser.getUserName(), project, token );
		String highestRole = loginService.getHighestRole( loggedInuser.getRole() );
		session.setAttribute( "username", loggedInuser.getUserName() );
		session.setAttribute( Constants.TOKEN, newToken );
		session.setAttribute( "role", highestRole );
		loggedInuser.setProfilePic( loggedInUser.getProfilePic() );
		session.setAttribute( Constants.LOGGED_IN_USER, loggedInuser );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), newToken ) );
		projectService.reloadRoleConfiguration( project, newToken );
		return "redirect:/projects/details/" + project;
	}

	@PostMapping( "/updateProject" )
	public String updateProject( HttpServletResponse response, @ModelAttribute ProjectRequestDto projectRequestDto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		int projectNameExist = 0;

		if ( !projectService.findById( projectRequestDto.getId(), token ).getName().contentEquals( projectRequestDto.getName() ) ) {
			projectNameExist = projectService.countByCompanyIdAndName( loggedInUser.getCompanyId(), projectRequestDto.getName(), token );
		}

		if ( projectNameExist > 0 ) {
			log.error( Constants.PROJECT_ALREADY_EXISTS );
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.PROJECT_ALREADY_EXISTS );
		} else {
			ProjectResponseDto updatedProject = projectService.updateProject( projectRequestDto, loggedInUser, ( String ) session.getAttribute( Constants.TOKEN ) );
			if ( updatedProject != null ) {
				Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
				if ( defaultProjectId == null ) {
					boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( projectRequestDto, loggedInUser.getId() );

					if ( isLoggedInUserPresent ) {
						session.setAttribute( Constants.DEFAULT_PROJECT_ID, updatedProject.getId() );
						session.setAttribute( Constants.DEFAULT_PROJECT_NAME, updatedProject.getName() );
						cookies.setDefaultProject( response, updatedProject.getId(), updatedProject.getName() );
					}
				}
				ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.UPDATE_PROJECT_SUCCESS );
			} else {
				ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.UPDATE_PROJECT_ERROR );
			}
		}

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		return "redirect:/projects/allproject?pageNo=0";

	}

	@PostMapping( "/removeUser" )
	public String removeUser( HttpServletResponse response, @ModelAttribute ProjectUserRequestDto projectUserRequestDto, Model model, HttpSession session, RedirectAttributes ra ) throws URISyntaxException {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String removeUser = projectService.removeUser( projectUserRequestDto, loggedInUser, ( String ) session.getAttribute( Constants.TOKEN ) );

		if ( Constants.REMOVE_USER_SUCCESS.equals( removeUser ) )
			model.addAttribute( Constants.SUCCESS_MESSAGE, removeUser );
		else
			model.addAttribute( Constants.ERROR_MESSAGE, removeUser );

		ProjectPagerDto list = projectService.findAll( loggedInUser,
				( String ) session.getAttribute( Constants.TOKEN ), 0 );
		model.addAttribute( "list", list );
		ProjectResponseDto project = projectService.findById( projectUserRequestDto.getId(), ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );
		List<UserDropdownResponseDto> userList = projectService.getUsersDropdown( ( String ) session.getAttribute( Constants.TOKEN ) );

		Set<UserDropdownResponseDto> availableOwners = projectUtilities.generateOwnersList( project, userList );
		Set<UserDropdownResponseDto> availableUsers = projectUtilities.generateUsersList( project, userList );
		model.addAttribute( Constants.OWNER_LIST, availableOwners );
		model.addAttribute( Constants.USER_LIST, availableUsers );

		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( project.getUsers(), loggedInUser.getId() );
		if ( !isLoggedInUserPresent && Objects.equals( defaultProjectId, project.getId() ) ) {
			List<ProjectDropdownResponseDto> projects = projectUtilities.getProjectDropdown( session, true );
			if ( !projects.isEmpty() ) {
				session.setAttribute( Constants.DEFAULT_PROJECT_ID, projects.get( 0 ).getId() );
				session.setAttribute( Constants.DEFAULT_PROJECT_NAME, projects.get( 0 ).getName() );
				cookies.setDefaultProject( response, projects.get( 0 ).getId(), projects.get( 0 ).getName() );
			} else {
				session.setAttribute( Constants.DEFAULT_PROJECT_ID, null );
				session.setAttribute( Constants.DEFAULT_PROJECT_NAME, null );
				cookies.setDefaultProject( response, null, null );
			}
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.UPDATE_PROJECT;
	}

	@PostMapping( "/removeOwner" )
	public String removeOwner( HttpServletResponse response, @ModelAttribute ProjectUserRequestDto projectUserRequestDto, Model model, HttpSession session ) throws URISyntaxException {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String removeOwner = projectService.removeOwner( projectUserRequestDto, loggedInUser, ( String ) session.getAttribute( Constants.TOKEN ) );

		if ( Constants.REMOVE_OWNER_SUCCESS.equals( removeOwner ) )
			model.addAttribute( Constants.SUCCESS_MESSAGE, removeOwner );
		else
			model.addAttribute( Constants.ERROR_MESSAGE, removeOwner );

		ProjectPagerDto list = projectService.findAll( ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER ),
				( String ) session.getAttribute( Constants.TOKEN ), 0 );
		model.addAttribute( "list", list );
		ProjectResponseDto project = projectService.findById( projectUserRequestDto.getId(), ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );
		List<UserDropdownResponseDto> ownerList = projectService.getUsersDropdown( ( String ) session.getAttribute( Constants.TOKEN ) );

		Set<UserDropdownResponseDto> availableOwners = projectUtilities.generateOwnersList( project, ownerList );
		Set<UserDropdownResponseDto> availableUsers = projectUtilities.generateUsersList( project, ownerList );
		model.addAttribute( Constants.OWNER_LIST, availableOwners );
		model.addAttribute( Constants.USER_LIST, availableUsers );

		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( project.getOwners(), loggedInUser.getId() );
		if ( !isLoggedInUserPresent && Objects.equals( defaultProjectId, project.getId() ) ) {
			List<ProjectDropdownResponseDto> projects = projectUtilities.getProjectDropdown( session, true );
			if ( !projects.isEmpty() ) {
				session.setAttribute( Constants.DEFAULT_PROJECT_ID, projects.get( 0 ).getId() );
				session.setAttribute( Constants.DEFAULT_PROJECT_NAME, projects.get( 0 ).getName() );
				cookies.setDefaultProject( response, projects.get( 0 ).getId(), projects.get( 0 ).getName() );
			} else {
				session.setAttribute( Constants.DEFAULT_PROJECT_ID, null );
				session.setAttribute( Constants.DEFAULT_PROJECT_NAME, null );
				cookies.setDefaultProject( response, projects.get( 0 ).getId(), projects.get( 0 ).getName() );
			}
		}

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.UPDATE_PROJECT;

	}

	@PostMapping( "/addOwner" )
	public String addOwner( @ModelAttribute ProjectUserRequestDto projectUserRequestDto, Model model, HttpSession session, HttpServletResponse response ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		projectService.addOwner( projectUserRequestDto, loggedInUser, ( String ) session.getAttribute( Constants.TOKEN ) );
		ProjectResponseDto project = projectService.findById( projectUserRequestDto.getId(), ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );
		List<UserDropdownResponseDto> ownerList = projectService.getUsersDropdown( ( String ) session.getAttribute( Constants.TOKEN ) );

		Set<UserDropdownResponseDto> availableOwners = projectUtilities.generateOwnersList( project, ownerList );
		Set<UserDropdownResponseDto> availableUsers = projectUtilities.generateUsersList( project, ownerList );
		model.addAttribute( Constants.OWNER_LIST, availableOwners );
		model.addAttribute( Constants.USER_LIST, availableUsers );

		model.addAttribute( Constants.SUCCESS_MESSAGE, Constants.ADD_OWNER_SUCCESS );

		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( project.getOwners(), loggedInUser.getId() );
		if ( isLoggedInUserPresent && defaultProjectId == null ) {
			session.setAttribute( Constants.DEFAULT_PROJECT_ID, project.getId() );
			session.setAttribute( Constants.DEFAULT_PROJECT_NAME, project.getName() );
			cookies.setDefaultProject( response, project.getId(), project.getName() );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.UPDATE_PROJECT;

	}

	@PostMapping( "/addUser" )
	public String addUser( HttpServletResponse response, @ModelAttribute ProjectUserRequestDto projectUserRequestDto, Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		projectService.addUser( projectUserRequestDto, loggedInUser, ( String ) session.getAttribute( Constants.TOKEN ) );
		ProjectResponseDto project = projectService.findById( projectUserRequestDto.getId(), ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );
		List<UserDropdownResponseDto> userList = projectService.getUsersDropdown( ( String ) session.getAttribute( Constants.TOKEN ) );

		Set<UserDropdownResponseDto> availableOwners = projectUtilities.generateOwnersList( project, userList );
		Set<UserDropdownResponseDto> availableUsers = projectUtilities.generateUsersList( project, userList );
		model.addAttribute( Constants.OWNER_LIST, availableOwners );
		model.addAttribute( Constants.USER_LIST, availableUsers );

		model.addAttribute( Constants.SUCCESS_MESSAGE, Constants.ADD_USER_SUCCESS );

		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( project.getUsers(), loggedInUser.getId() );
		if ( isLoggedInUserPresent && defaultProjectId == null ) {
			session.setAttribute( Constants.DEFAULT_PROJECT_ID, project.getId() );
			session.setAttribute( Constants.DEFAULT_PROJECT_NAME, project.getName() );
			cookies.setDefaultProject( response, project.getId(), project.getName() );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.UPDATE_PROJECT;

	}

	@GetMapping( "/details/{projectId}" )
	public String getProjectDetails( Model model, HttpSession session, @PathVariable Long projectId ) {
		ProjectResponseDto project = projectService.findById( projectId, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "projects/details";
	}

	@GetMapping( "/userProject" )
	public String scrumMasterProject( Model model, HttpSession session ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		long companyId = loggedInUser.getCompanyId();

		List<ProjectResponseDto> list = projectService.scrumMasterProject( loggedInUser.getId(), companyId, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, list );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "projects/projectOfScrumMaster";
	}

	@GetMapping( "/default/{project}" )
	public String ProjectDashboard( @PathVariable Long project, HttpSession session, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		ProjectResponseDto existingProject = projectService.findById( project, ( String ) session.getAttribute( Constants.TOKEN ) );
		List<SprintDto> previuosSprints = sprintService.findPreviousSprints( token, loggedInUser.getCompanyId(), project );
		session.setAttribute( "previousSprints", previuosSprints );
		List<ScrumTeamResponseDto> scrumTeams = scrumMasterService.findAllScrumTeamsForProject( loggedInUser.getCompanyId(), project, token );
		session.setAttribute( "scrumTeams", scrumTeams );
		Map<String, Integer> taskCountReport1 = projectService.findTaskCountForProject( loggedInUser.getCompanyId(), project, token );
		try {
			int total = taskCountReport1.get( "total" );
			int complated = taskCountReport1.get( "completed" );
			double completedTasksWidth = ( complated / ( double ) total ) * 100;
			model.addAttribute( "completedTasksWidth", completedTasksWidth );
			SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), project );
			dto.setCompletedTasksWidth( completedTasksWidth );
			session.setAttribute( "activeSprints", dto );

		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}
		session.setAttribute( Constants.DEFAULT_PROJECT_NAME, existingProject.getName() );
		String newToken = loginService.getDefaultProjectToken( loggedInUser.getUserName(), project, token );
		session.setAttribute( Constants.TOKEN, newToken );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), newToken ) );
		projectService.reloadRoleConfiguration( project, newToken );
		return "redirect:/projects/details1/" + project;
	}

	@GetMapping( "/details1/{projectId}" )
	public String getProjectDetailsDashboard( Model model, HttpSession session, @PathVariable Long projectId ) {
		ProjectResponseDto project = projectService.findById( projectId, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );
		return "projects/projectDashboard";
	}

	@GetMapping( "/project/dashboard/{projectId}" )
	public String projectDetailsDashboard( Model model, HttpSession session, @PathVariable Long projectId ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		ProjectResponseDto project = projectService.findById( projectId, token );
		model.addAttribute( Constants.PROJECT, project );

		List<SprintDto> previuosSprints = sprintService.findPreviousSprints( token, loggedInUser.getCompanyId(), projectId );
		model.addAttribute( "previousSprints", previuosSprints );

		List<ScrumTeamResponseDto> scrumTeams = scrumMasterService.findAllScrumTeamsForProject( loggedInUser.getCompanyId(), projectId, token );
		model.addAttribute( "scrumTeams", scrumTeams );

		Map<String, Integer> taskCountReport1 = projectService.findTaskCountForProject( loggedInUser.getCompanyId(), projectId, token );

		try {
			int total = taskCountReport1.get( "total" );
			int complated = taskCountReport1.get( "completed" );
			double completedTasksWidth = ( complated / ( double ) total ) * 100;
			model.addAttribute( "completedTasksWidth", completedTasksWidth );
			SprintDto dto = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), projectId );
			dto.setCompletedTasksWidth( completedTasksWidth );
			model.addAttribute( "activeSprints", dto );
		} catch ( Exception e ) {
			log.error( e.getMessage(), e );
		}

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

		return "projects/projectDetailsDashboard";
	}

}
