package com.pluck.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
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
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.task.DatatableResponseDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.StoryPointConfigurationDto;
import com.pluck.dto.task.TaskAttachmentRequestDto;
import com.pluck.dto.task.TaskAttachmentResponseDto;
import com.pluck.dto.task.TaskCommentResponseDto;
import com.pluck.dto.task.TaskCommonModalDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.dto.task.TaskPagerDto;
import com.pluck.dto.user.UserDropdownResponseDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectService;
import com.pluck.service.ScrumTeamService;
import com.pluck.service.SprintService;
import com.pluck.service.StoryPointService;
import com.pluck.service.TaskCommentService;
import com.pluck.service.TaskService;
import com.pluck.utilites.ProjectUtilities;
import com.pluck.utilites.StatusWrapper;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/tasks" )
@Controller
@AllArgsConstructor
public class TaskController {

	private final ProjectService projectService;
	private final TaskService service;
	private final ProjectUtilities projectUtilities;
	private SprintService sprintService;
	private StoryPointService storyPointService;
	private final NotificationService notificationService;
	private final TaskCommentService taskCommentService;
	private final DropdownCache dropdownCache;
	private final ScrumTeamService scrumTeamService;

	@GetMapping( "/addTaskForm" )
	public String addForm( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );
		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( defaultProjectId );
		List<SeverityConfigurationDto> severityList = dropdownCache.getSeverities( defaultProjectId );
		List<StatusConfigurationDto> taskStatus = dropdownCache.getStatuses( defaultProjectId );
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<String> taskType = service.getTaskType( token );
		List<StoryPointConfigurationDto> storyPoint = storyPointService.findAll( token, loggedInUser.getCompanyId(), defaultProjectId );
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
		model.addAttribute( Constants.TASKTYPE, taskType );
		model.addAttribute( Constants.PRIORITIES, priorityList );
		model.addAttribute( Constants.SEVERITIES, severityList );
		model.addAttribute( Constants.TASK_STATUS, taskStatus );
		model.addAttribute( Constants.SPRINTS, sprints );
		model.addAttribute( "storyPoint", storyPoint );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return "tasks/addTask";
	}

	@PostMapping
	public String addTask( @ModelAttribute TaskDto dto, HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Long companyId = loggedInUser.getCompanyId();
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_TASK );
			return "tasks/addTask";
		}
		dto.setProject( defaultProjectId );
		dto.setCompany( companyId );
		dto.setAddedBy( loggedInUser.getId() );

		String addedTask = service.addTask( dto, ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser.getCompanyId(),
				defaultProjectId, loggedInUser );
		if ( Constants.ADD_TASK_SUCCESS.equals( addedTask ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, dto.getTaskType() + " added successfully" );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, addedTask + " " + dto.getTaskType() );
		return "redirect:/tasks?pageNo=0";
	}

	@GetMapping
	public String getAllTask( HttpSession session, Model model, @ModelAttribute( Constants.MESSAGE ) String message,
			@RequestParam int pageNo ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		if ( defaultProjectId != null ) {
			TaskPagerDto list = service.allUserTask( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
					pageNo, loggedInUser.getCompanyId(), ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID ) );
			model.addAttribute( Constants.TASK_LIST, list );
			List<String> selectedStatus = Arrays.asList( "None" );
			model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );
		}

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.ALL_TASKS;
	}

	@GetMapping( "/paginate" )
	@ResponseBody
	public ResponseEntity<DatatableResponseDto> allTasksBySearchQuery( @RequestParam( required = false ) Integer page, @RequestParam( required = false ) int size, @RequestParam( required = false ) String query,
			HttpSession session ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		DatatableResponseDto response = new DatatableResponseDto();

		if ( query != null && !query.isEmpty() ) {
			TaskPagerDto taskPage = service.allTasksBySearchQuery( ( String ) session.getAttribute( Constants.TOKEN ), page, size, query, loggedInUser.getCompanyId(), ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID ) );
			response.setData( taskPage.getContent() );
			response.setTotalCount( taskPage.getTotalElements() );
			response.setRecordsFiltered( taskPage.getTotalElements() );
		} else {
			TaskPagerDto taskPage = service.allUserTask( token, page, size, loggedInUser.getCompanyId(), defaultProjectId );
			response.setData( taskPage.getContent() );
			response.setTotalCount( taskPage.getTotalElements() );
			response.setRecordsFiltered( taskPage.getTotalElements() );
		}

		return ResponseEntity.ok( response );
	}

	@GetMapping( "/updateTaskForm/{taskId}" )
	public String getUpdateUserTaskForm( Model model, HttpSession session, @PathVariable Long taskId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<UserDropdownResponseDto> allUsers = projectService.getUsersDropdown( token );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );

		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( defaultProjectId );
		List<SeverityConfigurationDto> severityList = dropdownCache.getSeverities( defaultProjectId );
		List<StatusConfigurationDto> taskStatus = dropdownCache.getStatuses( defaultProjectId );
		List<String> taskType = service.getTaskType( token );
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<StoryPointConfigurationDto> storyPoints = storyPointService.findAll( token, loggedInUser.getCompanyId(), defaultProjectId );
		TaskDto task = service.findTaskById( token, taskId, loggedInUser.getCompanyId(), defaultProjectId );

		if ( task.getTaskType().equals( "User Story" ) ) {
			return "redirect:/stories/updateStoryForm/" + taskId;
		}

		List<TaskCommentResponseDto> commentList = taskCommentService.getAllTaskComment( taskId, loggedInUser.getCompanyId(), token );
		commentList.sort( Comparator.comparing( TaskCommentResponseDto::getAddedOn ).reversed() );

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

		model.addAttribute( "allComment", commentList );
		model.addAttribute( "users", allUsers );
		model.addAttribute( Constants.TASKTYPE, taskType );
		model.addAttribute( Constants.PRIORITIES, priorityList );
		model.addAttribute( Constants.SEVERITIES, severityList );
		model.addAttribute( Constants.TASK_STATUS, taskStatus );
		model.addAttribute( "task", task );
		model.addAttribute( Constants.SPRINTS, sprints );
		model.addAttribute( Constants.STORY_POINTS, storyPoints );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return ViewConstants.UPDATE_TASK;
	}

	@GetMapping( "/updateTaskForm/{taskId}/{projectId}" )
	public String getUpdateUserTaskFormForDashboard( Model model, HttpSession session, @PathVariable Long taskId, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		//Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<UserDropdownResponseDto> allUsers = projectService.getUsersDropdown( token );
		Set<UserResponseDTO> list = projectService.allUsersByProject( projectId, loggedInUser.getCompanyId(), token, 0 );

		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( projectId );
		List<SeverityConfigurationDto> severityList = dropdownCache.getSeverities( projectId );
		List<StatusConfigurationDto> taskStatus = dropdownCache.getStatuses( projectId );
		List<String> taskType = service.getTaskType( token );
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), projectId );
		List<StoryPointConfigurationDto> storyPoints = storyPointService.findAll( token, loggedInUser.getCompanyId(), projectId );
		TaskDto task = service.findTaskById( token, taskId, loggedInUser.getCompanyId(), projectId );

		List<TaskCommentResponseDto> commentList = taskCommentService.getAllTaskComment( taskId, loggedInUser.getCompanyId(), token );
		commentList.sort( Comparator.comparing( TaskCommentResponseDto::getAddedOn ).reversed() );

		List<UserResponseDTO> usersOfScrumTeams = scrumTeamService.findAllScrumTeamUsersForProject( token, loggedInUser.getCompanyId(), projectId );
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

		model.addAttribute( "allComment", commentList );
		model.addAttribute( "users", allUsers );
		model.addAttribute( Constants.TASKTYPE, taskType );
		model.addAttribute( Constants.PRIORITIES, priorityList );
		model.addAttribute( Constants.SEVERITIES, severityList );
		model.addAttribute( Constants.TASK_STATUS, taskStatus );
		model.addAttribute( "task", task );
		model.addAttribute( Constants.SPRINTS, sprints );
		model.addAttribute( Constants.STORY_POINTS, storyPoints );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), token ) );
		return ViewConstants.UPDATE_TASK;
	}

	@ResponseBody
	@GetMapping( "/updateTaskFormModal/{taskId}/{projectId}" )
	public TaskCommonModalDto getUpdateTaskModal( HttpSession session, @PathVariable Long taskId, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = null;
		if ( projectId != 0 ) {
			defaultProjectId = projectId;
		} else {
			defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		}
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<UserDropdownResponseDto> allUsers = projectService.getUsersDropdown( token );
		Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), token, 0 );

		List<PriorityConfigurationDto> priorityList = dropdownCache.getPriorities( defaultProjectId );
		List<SeverityConfigurationDto> severityList = dropdownCache.getSeverities( defaultProjectId );
		List<StatusConfigurationDto> taskStatus = dropdownCache.getStatuses( defaultProjectId );
		List<String> taskType = service.getTaskType( token );
		List<SprintDto> sprints = sprintService.findAvailableSprints( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<StoryPointConfigurationDto> storyPoints = storyPointService.findAll( token, loggedInUser.getCompanyId(), defaultProjectId );
		TaskDto task = service.findTaskById( token, taskId, loggedInUser.getCompanyId(), defaultProjectId );
		List<TaskCommentResponseDto> commentList = taskCommentService.getAllTaskComment( taskId, loggedInUser.getCompanyId(), token );

		List<UserResponseDTO> usersOfScrumTeams = scrumTeamService.findAllScrumTeamUsersForProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<Long> usersOfScrumTeamsIds = usersOfScrumTeams.stream().map( user -> user.getId() ).collect( Collectors.toList() );
		List<UserResponseDTO> listOfOtherUsers = list.stream().filter( user -> {
			if ( usersOfScrumTeamsIds.contains( user.getId() ) ) {
				return false;
			} else {
				return true;
			}
		} ).collect( Collectors.toList() );

		commentList.stream().forEach( comment -> {
			allUsers.stream().forEach( user -> {
				if ( comment.getAddedBy() == user.getId() ) {
					comment.setFirstName( user.getFirstName() );
					comment.setLastName( user.getLastName() );
				}
			} );
		} );

		TaskCommonModalDto taskCommonModalDto = new TaskCommonModalDto();

		List<ProjectDropdownResponseDto> projectList = projectUtilities.getProjectDropdown( session, false );

		taskCommonModalDto.setOtherUsers( listOfOtherUsers );
		taskCommonModalDto.setScrumUsers( usersOfScrumTeams );
		taskCommonModalDto.setLists( list );
		taskCommonModalDto.setAllComment( commentList );
		taskCommonModalDto.setUsers( allUsers );
		taskCommonModalDto.setTaskType( taskType );
		taskCommonModalDto.setPriorities( priorityList );
		taskCommonModalDto.setSeverties( severityList );
		taskCommonModalDto.setTaskStatus( taskStatus );
		taskCommonModalDto.setTask( task );
		taskCommonModalDto.setSprints( sprints );
		taskCommonModalDto.setTaskStoryPoint( storyPoints );
		taskCommonModalDto.setProjectList( projectList );
		return taskCommonModalDto;
	}

	@PostMapping( "/update/task" )
	public String updateTask( TaskDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long tempDefaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		Long defaultProjectId = null;
		Long tempProject = null;

		if ( dto.getProject() == null ) {
			defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		} else {
			defaultProjectId = dto.getProject();
			tempProject = defaultProjectId;
		}

		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_UPDATE_TASK );
			return ViewConstants.UPDATE_TASK;
		}
		String status = service.getStatusById( token, dto.getId(), loggedInUser.getCompanyId(), defaultProjectId );
		dto.setStatus( status );
		dto.setProject( defaultProjectId );
		dto.setCompany( companyId );
		dto.setStory_point( dto.getStory_point() );
		dto.setUpdatedBy( loggedInUser.getId() );
		dto.setFirstName( loggedInUser.getFirstName() );
		dto.setLastName( loggedInUser.getLastName() );
		String updatedTask = service.updateTask( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( updatedTask != null ) {
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.UPDATE_TASK_SUCCESS );
		} else {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.UPDATE_TASK_ERROR );
		}

		if ( tempProject == null )
			return "redirect:/tasks/updateTaskForm/" + dto.getId();
		else if ( !dto.getProject().equals( tempDefaultProjectId ) )
			return "redirect:/tasks/updateTaskForm/" + dto.getId() + "/" + dto.getProject();
		else
			return "redirect:/tasks/updateTaskForm/" + dto.getId();
	}

	@ResponseBody
	@PostMapping( "/update/task-attachment" )
	public String updateTaskAttachmentsModal( @ModelAttribute TaskDto dto, Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompany( loggedInUser.getCompanyId() );
		dto.setProject( ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID ) );
		dto.setUpdatedBy( loggedInUser.getId() );
		return service.updateTaskAttachmentsModal( dto, ( String ) session.getAttribute( Constants.TOKEN ) );
	}

	@PostMapping( "/update/task1" )
	public String updateTask1( TaskDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_UPDATE_TASK );
			return ViewConstants.UPDATE_TASK;
		}
		dto.setProject( defaultProjectId );
		dto.setCompany( companyId );
		dto.setUpdatedBy( loggedInUser.getId() );
		TaskDto updatedTask = service.updateTask1( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( updatedTask != null ) {
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.UPDATE_TASK_SUCCESS );
		} else {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.UPDATE_TASK_ERROR );
		}

		return "redirect:/sprints/active-sprint-history/" + updatedTask.getSprint();
	}

	@PostMapping( "/update/task/{projectId}/{sprintId}" )
	public String updateDashboardTasksDragDrop( @PathVariable Long projectId, @PathVariable Long sprintId, TaskDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_UPDATE_TASK );
			return ViewConstants.UPDATE_TASK;
		}
		dto.setProject( defaultProjectId );
		dto.setCompany( companyId );
		dto.setUpdatedBy( loggedInUser.getId() );
		TaskDto updatedTask = service.updateTask1( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( updatedTask != null ) {
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.UPDATE_TASK_SUCCESS );
		} else {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.UPDATE_TASK_ERROR );
		}

		return "redirect:/dashboard/stories/" + projectId + "/" + sprintId;
	}

	@ResponseBody
	@PostMapping( "/updateTaskModal" )
	public String updateTaskModal( @ModelAttribute TaskDto dto, Model model, HttpSession session, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = null;
		if ( dto.getProject() != 0 ) {
			defaultProjectId = dto.getProject();
		} else {
			defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		}
		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.ERROR_MESSAGE, Constants.DEFAULT_PROJECT_NULL_UPDATE_TASK );
			return ViewConstants.UPDATE_TASK;
		}
		dto.setProject( defaultProjectId );
		dto.setCompany( companyId );
		dto.setStory_point( dto.getStory_point() );
		dto.setUpdatedBy( loggedInUser.getId() );
		dto.setFirstName( loggedInUser.getFirstName() );
		dto.setLastName( loggedInUser.getLastName() );
		String updatedTask = service.updateTaskModal( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		if ( updatedTask != null ) {
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.UPDATE_TASK_SUCCESS );
		} else {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.UPDATE_TASK_ERROR );
		}

		return "redirect:/tasks/updateTaskForm/" + dto.getId();
	}

	@ResponseBody
	@PostMapping( "/filter/status" )
	public TaskPagerDto getTaskByFilter( @ModelAttribute StatusWrapper status, HttpSession session, @RequestParam int pageNo, @RequestParam( value = "statusValues[]", required = false ) List<String> statusValues, @RequestParam( "typeValue" ) String typeValue, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();

		List<String> statusValues1 = status.getStatus();

		if ( statusValues1 == null ) {
			statusValues1 = new ArrayList<>();
			status.setStatus( statusValues );
		}

		if ( status.getType() == null ) {
			status.setType( typeValue );
		}

		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		TaskPagerDto list = service.findTaskByStatus( status, token, companyId, defaultProjectId, pageNo );

		return list;
	}

	@ResponseBody
	@GetMapping( "/delete/attachment/{id}" )
	public String deleteTask( @PathVariable Long id, TaskDto dto, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		int deleteTask = service.deleteTask( token, id, loggedInUser.getId(), loggedInUser.getCompanyId() );
		return deleteTask > 0 ? "File deleted" : "file not deleted";
	}

	@ResponseBody
	@GetMapping( "/updateAttchaments/{taskId}" )
	public List<TaskAttachmentResponseDto> getUpdateAttchments( HttpSession session, @PathVariable Long taskId ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return service.findAttachmentById( token, taskId );
	}

	@ResponseBody
	@GetMapping( "/top-five-tasks-by-project/{projectId}" )
	public List<TaskDto> findTop5TasksByProject( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return service.findTop5TasksByProject( loggedInUser.getCompanyId(), projectId, token );

	}

	@GetMapping( "/all-tasks/{projectId}" )
	public String getAllTaskByProject( HttpSession session, Model model, @ModelAttribute( Constants.MESSAGE ) String message,
			@RequestParam int pageNo, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		TaskPagerDto list = service.allUserTask( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
				pageNo, loggedInUser.getCompanyId(), projectId );
		model.addAttribute( Constants.TASK_LIST, list );
		List<String> selectedStatus = Arrays.asList( "None" );
		model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.ALL_TASKS;
	}

	@GetMapping( "/all-tasks1/{projectId}" )
	public String allTaskByProject( HttpSession session, Model model, @ModelAttribute( Constants.MESSAGE ) String message,
			@RequestParam int pageNo, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		TaskPagerDto list = service.allTaskByProject( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
				loggedInUser.getCompanyId(), projectId );
		model.addAttribute( Constants.TASK_LIST, list );
		List<String> selectedStatus = Arrays.asList( "None" );
		model.addAttribute( Constants.SELECTED_STATUS, selectedStatus );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.ALL_TASKS;
	}

	@GetMapping( "/filter/status/by-project/{projectId}/{status}" )
	public String getTaskByFilter( @PathVariable Long projectId, @PathVariable String status, HttpSession session, @RequestParam int pageNo, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		StatusWrapper statusWrapper = new StatusWrapper();
		statusWrapper.setCompanyId( companyId );
		statusWrapper.setDefaultProjectId( projectId );
		List<String> statusList = Arrays.asList( status );
		statusWrapper.setStatus( statusList );
		TaskPagerDto list = service.findTaskByStatus( statusWrapper, token, companyId, projectId, pageNo );
		model.addAttribute( Constants.TASK_LIST, list );
		model.addAttribute( Constants.SELECTED_STATUS, statusWrapper.getStatus() );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		return ViewConstants.ALL_TASKS;
	}

	@GetMapping( "/all-tasks/user/{projectId}" )
	public String getAllTaskByUser( HttpSession session, Model model, @ModelAttribute( "message" ) String message,
			@RequestParam int pageNo, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long selectedUserId = ( Long ) session.getAttribute( "userId" );

		if ( selectedUserId == null ) {
			selectedUserId = loggedInUser.getId();
		}

		TaskPagerDto list = service.getAllTaskByUser( ( String ) session.getAttribute( Constants.TOKEN ), pageNo,
				loggedInUser.getCompanyId(), projectId, selectedUserId );
		model.addAttribute( "taskList", list );
		model.addAttribute( "projectId", projectId );
		List<String> selectedStatus = Arrays.asList( "None" );
		model.addAttribute( "selectedStatus", selectedStatus );
		model.addAttribute( "projectList", projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( "notifications", notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( "token" ) ) );
		return ViewConstants.ALL_TASKS;
	}

	@ResponseBody
	@GetMapping( "/tasks/filter" )
	public List<TaskDto> currentSprintTaskFilter( @RequestParam Long project, @RequestParam String status, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return service.TaskFilter( project, status, token );
	}

	private static int calculateTotalMinutes( String time ) {
		int totalMinutes = 0;
		String[] parts = time.split( " " );
		for ( String part : parts ) {
			if ( part.endsWith( "h" ) ) {
				totalMinutes += Integer.parseInt( part.replace( "h", "" ) ) * 60;
			} else if ( part.endsWith( "m" ) ) {
				totalMinutes += Integer.parseInt( part.replace( "m", "" ) );
			}
		}
		return totalMinutes;
	}

	@PostMapping( "/addTaskAttachment" )
	@ResponseBody
	public String addTaskAttachment( @ModelAttribute TaskAttachmentRequestDto taskAttachmentRequestDto, HttpSession session, RedirectAttributes ra, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		taskAttachmentRequestDto.setCompanyId( loggedInUser.getCompanyId() );
		taskAttachmentRequestDto.setUserId( loggedInUser.getId() );
		String message = service.addTaskAttachment( taskAttachmentRequestDto, token );
		return message;
	}

	@ResponseBody
	@GetMapping( "/status/{currentStatus}" )
	public List<StatusConfigurationDto> statusDropdownGenerator( @PathVariable String currentStatus, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		return service.statusDropdownGenerator( token, currentStatus, defaultProjectId, loggedInUser.getCompanyId() );
	}

	@ResponseBody
	@PostMapping( "/updateTaskStatus/{taskId}/{status}" )
	public String updateTaskStatus( @PathVariable Long taskId, @PathVariable String status, HttpSession session, RedirectAttributes ra ) {
		String updatedTask = service.updateTaskStatus( taskId, status );
		return updatedTask;
	}
}