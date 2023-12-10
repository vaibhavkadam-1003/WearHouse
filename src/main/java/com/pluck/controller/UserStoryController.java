package com.pluck.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.task.AcceptanceCriteriaDto;
import com.pluck.dto.task.DetailedUserStoryRequestDto;
import com.pluck.dto.task.DetailedUserStoryResponseDto;
import com.pluck.dto.task.ModuleDto;
import com.pluck.dto.task.QuickStoryPaginationResponse;
import com.pluck.dto.task.QuickUserStoryRequestDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.StoryPointConfigurationDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.dto.user.UserDropdownResponseDto;
import com.pluck.service.AcceptanceCriteriaService;
import com.pluck.service.ModuleService;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectService;
import com.pluck.service.ScrumTeamService;
import com.pluck.service.SprintService;
import com.pluck.service.StoryPointService;
import com.pluck.service.TaskService;
import com.pluck.service.UserStoryService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping( "/stories" )
public class UserStoryController {

	@Autowired
	private DropdownCache dropdownCache;

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private ProjectService projectService;

	@Autowired
	private TaskService taskService;

	@Autowired
	private SprintService sprintService;

	@Autowired
	private UserStoryService userStoryService;

	@Autowired
	private ModuleService moduleService;

	@Autowired
	private AcceptanceCriteriaService criteriaService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private StoryPointService storyPointService;

	@Autowired
	private ScrumTeamService scrumTeamService;

	@Autowired
	private TaskService service;

	@GetMapping( "/addDetailedStoryForm" )
	public String getDetailedUserStoryForm( Model model, HttpSession session ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		List<String> storyStatus = service.getTaskStatus( token );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		List<UserResponseDTO> usersOfScrumTeams = scrumTeamService.findAllScrumTeamUsersForProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<Long> usersOfScrumTeamsIds = usersOfScrumTeams.stream().map( user -> user.getId() ).collect( Collectors.toList() );
		List<UserResponseDTO> listOfOtherUsers = list.stream().filter( user -> {
			if ( usersOfScrumTeamsIds.contains( user.getId() ) ) {
				return false;
			} else {
				return true;
			}
		} ).collect( Collectors.toList() );

		List<UserResponseDTO> activeOtherUsers = new ArrayList<>();
		for ( UserResponseDTO otherUser : listOfOtherUsers ) {
			if ( "Active".equals( otherUser.getStatus() ) ) {
				activeOtherUsers.add( otherUser );
			}
		}

		List<UserResponseDTO> activeScrumUsers = new ArrayList<>();
		for ( UserResponseDTO scrumUsers : usersOfScrumTeams ) {
			if ( "Active".equals( scrumUsers.getStatus() ) ) {
				activeScrumUsers.add( scrumUsers );
			}
		}

		model.addAttribute( "otherUsers", activeOtherUsers );
		model.addAttribute( "scrumUsers", activeScrumUsers );
		model.addAttribute( "lists", list );
		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( defaultProjectId );
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<ModuleDto> modules = moduleService.findAll( defaultProjectId, loggedInUser.getCompanyId(), token );
		List<AcceptanceCriteriaDto> criterias = criteriaService.findAll( defaultProjectId, loggedInUser.getCompanyId(), token );
		List<StoryPointConfigurationDto> storyPoint = storyPointService.findAll( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( Constants.STORY_STATUS, storyStatus );
		model.addAttribute( Constants.STORY_POINT, storyPoint );
		model.addAttribute( Constants.PRIORITIES, priorityList );
		model.addAttribute( "sprints", sprints );
		model.addAttribute( "modules", modules );
		model.addAttribute( "criterias", criterias );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );

		return "tasks/addDetailedStory";
	}

	@PostMapping( "/detailed" )
	public String addDetailedStory( @ModelAttribute DetailedUserStoryRequestDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		dto.getTask().setAddedBy( loggedInUser.getId() );
		dto.getTask().setFirstName( loggedInUser.getFirstName() );
		dto.getTask().setLastName( loggedInUser.getLastName() );
		dto.getTask().setLoggedInUserId( loggedInUser.getId() );
		String addedStatus = userStoryService.addDetailedStory( dto, token, loggedInUser.getCompanyId(), defaultProjectId, loggedInUser.getFirstName(), loggedInUser.getLastName(), loggedInUser.getId() );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		if ( Constants.ADD_STORY_SUCCESS.equals( addedStatus ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, addedStatus );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, addedStatus );

		return ViewConstants.REDIRECT_TO_ALL_TASK;
	}

	@GetMapping( "/addQuickStoryForm" )
	public String getUserStoryForm( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		List<StoryPointConfigurationDto> storyPoint = storyPointService.findAll( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( "storyPoint", storyPoint );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( defaultProjectId );
		List<UserResponseDTO> usersOfScrumTeams = scrumTeamService.findAllScrumTeamUsersForProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<Long> usersOfScrumTeamsIds = usersOfScrumTeams.stream().map( user -> user.getId() ).collect( Collectors.toList() );
		List<UserResponseDTO> listOfOtherUsers = list.stream().filter( user -> {
			if ( usersOfScrumTeamsIds.contains( user.getId() ) ) {
				return false;
			} else {
				return true;
			}
		} ).collect( Collectors.toList() );

		List<UserResponseDTO> activeOtherUsers = new ArrayList<>();
		for ( UserResponseDTO otherUser : listOfOtherUsers ) {
			if ( "Active".equals( otherUser.getStatus() ) ) {
				activeOtherUsers.add( otherUser );
			}
		}

		List<UserResponseDTO> activeScrumUsers = new ArrayList<>();
		for ( UserResponseDTO scrumUsers : usersOfScrumTeams ) {
			if ( "Active".equals( scrumUsers.getStatus() ) ) {
				activeScrumUsers.add( scrumUsers );
			}
		}

		model.addAttribute( "otherUsers", activeOtherUsers );
		model.addAttribute( "scrumUsers", activeScrumUsers );
		model.addAttribute( "lists", list );
		model.addAttribute( Constants.PRIORITIES, priorityList );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );

		return "tasks/addQuickStory";
	}

	@PostMapping( "/quick" )
	public String addQuickStory( @ModelAttribute QuickUserStoryRequestDto dto, HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_STORY );
			return "tasks/addStory";
		}
		dto.getTask().setProject( defaultProjectId );
		dto.getTask().setCompany( loggedInUser.getCompanyId() );
		dto.getTask().setAddedBy( loggedInUser.getId() );
		dto.getTask().setFirstName(loggedInUser.getFirstName());
		dto.getTask().setLastName(loggedInUser.getLastName());
		String isAdded = userStoryService.addQuickStory( dto, ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser.getCompanyId(), defaultProjectId );

		if ( Constants.ADD_STORY_SUCCESS.equals( isAdded ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isAdded );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, isAdded );

		return ViewConstants.REDIRECT_TO_ALL_TASK;
	}

	@GetMapping
	public String getAllStories( HttpSession session, Model model, @ModelAttribute( Constants.MESSAGE ) String message, @RequestParam int pageNo ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		if ( defaultProjectId != null ) {
			QuickStoryPaginationResponse list = userStoryService.allUserStories( token, pageNo, loggedInUser.getCompanyId(), ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID ) );
			model.addAttribute( "list", list );
		}
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "tasks/allStories";
	}

	@GetMapping( "/updateStoryForm/{storyId}" )
	public String getUpdateUserStoryForm( Model model, HttpSession session, @PathVariable Long storyId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		DetailedUserStoryResponseDto story = userStoryService.findUserStoryById( token, storyId, loggedInUser.getCompanyId() );

		List<UserDropdownResponseDto> allUsers = projectService.getUsersDropdown( token );

		List<ModuleDto> modules = moduleService.findAll( defaultProjectId, loggedInUser.getCompanyId(), token );
		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( defaultProjectId );
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<String> storyStatus = service.getTaskStatus( token );
		List<AcceptanceCriteriaDto> criterias = criteriaService.findAll( defaultProjectId, loggedInUser.getCompanyId(), token );
		Set<Integer> existingCriteriaIds = story.getAgile().getAcceptanceCriteria().stream().map( AcceptanceCriteriaDto::getId ).collect( Collectors.toSet() );
		List<AcceptanceCriteriaDto> uniqueCriterias = criterias.stream().filter( criteria -> {
			if ( existingCriteriaIds.contains( criteria.getId() ) ) {
				return false;
			} else
				return true;
		} ).collect( Collectors.toList() );

		List<StoryPointConfigurationDto> storyPoints = storyPointService.findAll( token, loggedInUser.getCompanyId(), defaultProjectId );
		TaskDto task = taskService.findTaskById( token, storyId, loggedInUser.getCompanyId(), defaultProjectId );

		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		List<UserResponseDTO> usersOfScrumTeams = scrumTeamService.findAllScrumTeamUsersForProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<Long> usersOfScrumTeamsIds = usersOfScrumTeams.stream().map( user -> user.getId() ).collect( Collectors.toList() );
		List<UserResponseDTO> listOfOtherUsers = list.stream().filter( user -> {
			if ( usersOfScrumTeamsIds.contains( user.getId() ) ) {
				return false;
			} else {
				return true;
			}
		} ).collect( Collectors.toList() );

		List<UserResponseDTO> activeOtherUsers = new ArrayList<>();
		for ( UserResponseDTO otherUser : listOfOtherUsers ) {
			if ( "Active".equals( otherUser.getStatus() ) ) {
				activeOtherUsers.add( otherUser );
			}
		}

		List<UserResponseDTO> activeScrumUsers = new ArrayList<>();
		for ( UserResponseDTO scrumUsers : usersOfScrumTeams ) {
			if ( "Active".equals( scrumUsers.getStatus() ) ) {
				activeScrumUsers.add( scrumUsers );
			}
		}

		model.addAttribute( "otherUsers", activeOtherUsers );
		model.addAttribute( "scrumUsers", activeScrumUsers );
		model.addAttribute( Constants.STORY_STATUS, storyStatus );
		model.addAttribute( Constants.PRIORITIES, priorityList );
		model.addAttribute( "sprints", sprints );
		model.addAttribute( "users", allUsers );
		model.addAttribute( "data", story );
		model.addAttribute( "modules", modules );
		model.addAttribute( "criterias", uniqueCriterias );
		model.addAttribute( Constants.STORY_POINTS, storyPoints );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( "task", task );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );

		return "tasks/updateStory";
	}

	@PostMapping( "/quick/update" )
	public String updateQuickUserStory( @ModelAttribute QuickUserStoryRequestDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		dto.getTask().setUpdatedBy( loggedInUser.getId() );
		dto.getTask().setFirstName( loggedInUser.getFirstName() );
		dto.getTask().setLastName( loggedInUser.getLastName() );
		String updatedStatus = userStoryService.updateQuickStory( dto, token, loggedInUser.getCompanyId(), defaultProjectId );

		if ( Constants.UPDATE_STORY_SUCCESS.equals( updatedStatus ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, updatedStatus );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, updatedStatus );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.REDIRECT_TO_ALL_TASK;
	}

}
