package com.pluck.controller;

import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.report.SprintReportRequestDto;
import com.pluck.dto.report.TaskReportRequestDto;
import com.pluck.dto.task.Content;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectReportService;
import com.pluck.service.SprintService;
import com.pluck.service.UserService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping( "/reports" )
@AllArgsConstructor
@Slf4j
public class ProjectReportController {

	@Autowired
	private final ProjectReportService projectReportService;

	@Autowired
	private final UserService userService;

	@Autowired
	private final ProjectUtilities projectUtilities;

	@Autowired
	private final NotificationService notificationService;

	@Autowired
	private final DropdownCache dropdownCache;

	@Autowired
	private SprintService sprintService;

	@GetMapping( "/getProjectReport" )
	public String getProjectReport( HttpSession session, Model model, RedirectAttributes ra ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		List<Content> list = projectReportService.allUserTask( ( String ) session.getAttribute( Constants.TOKEN ),
				loggedInUser.getCompanyId(), ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID ) );
		model.addAttribute( Constants.TASK_LIST, list );

		List<TaskDto> completedTasks = projectReportService.findCompletedTasksByProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( "completedTasks", completedTasks );

		List<TaskDto> inCompletedTasks = projectReportService.findInCompletedTasksByProject( token, loggedInUser.getCompanyId(), defaultProjectId );
		model.addAttribute( "inCompletedTasks", inCompletedTasks );

		Map<String, Integer> storyCount = projectReportService.findStoryPointCountForProject( loggedInUser.getCompanyId(), defaultProjectId, token );
		model.addAttribute( "storyCount", storyCount );

		model.addAttribute( "incompletedTasksCount", list.size() - completedTasks.size() );
		float completedTasksWidth = ( completedTasks.size() / ( float ) list.size() ) * 100;
		int completedTasksWidth1 = Math.round( completedTasksWidth );
		model.addAttribute( "completedTasksWidth", completedTasksWidth1 );

		Integer scrumCount = projectReportService.countAllScrumTeams( loggedInUser.getCompanyId(), defaultProjectId, token );
		model.addAttribute( "totalScrumCount", scrumCount );

		Integer activeSprintCount = projectReportService.countAllActiveSprint( loggedInUser.getCompanyId(), defaultProjectId, token );
		model.addAttribute( "totalActiveSprintCount", activeSprintCount );

		Integer pervoiusSprintCount = projectReportService.countAllInactiveSprint( loggedInUser.getCompanyId(), defaultProjectId, token );
		model.addAttribute( "totalPervoiusSprintCount", pervoiusSprintCount );

		Set<UserResponseDTO> userList = projectReportService.allUsersByProject( defaultProjectId, loggedInUser.getCompanyId(), ( String ) session.getAttribute( Constants.TOKEN ) );
		Set<UserResponseDTO> list1 = userService.setEditableFlag( userList, defaultProjectId, ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser, ( String ) session.getAttribute( "role" ) );
		model.addAttribute( "userListByProject", list1 );

		ProjectResponseDto project = projectReportService.findById( defaultProjectId, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( Constants.PROJECT, project );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "reports/projectReport";
	}

	@GetMapping( "/getReportPage" )
	public String generateReport( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "reports/report";

	}

	@ResponseBody
	@PostMapping( "/tasks" )
	public List<TaskDto> generateTaskReport( @RequestBody TaskReportRequestDto dto, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		return projectReportService.generateTaskReport( dto, token );
	}

	@ResponseBody
	@GetMapping( "/users-by-project/{projectId}" )
	public Set<UserResponseDTO> allUsersByProject( HttpSession session, @PathVariable Long projectId ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return projectReportService.allUsersByProject( projectId, loggedInUser.getCompanyId(), token );
	}

	@ResponseBody
	@GetMapping( "/status-by-project/{projectId}" )
	public List<StatusConfigurationDto> allStatusByProject( HttpSession session, @PathVariable Long projectId ) {
		return dropdownCache.getStatuses( projectId );

	}

	@ResponseBody
	@GetMapping( "/active-sprints/{projectId}" )
	public List<SprintDto> getActiveSprintByProjectId( HttpSession session, @PathVariable Long projectId ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		return sprintService.findActiveSprints( token, loggedInUser.getCompanyId(), projectId );
	}

	@GetMapping( "/sprints/active/getReportPage" )
	public String generateActiveSprintReport( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "reports/activeSprintReport";

	}

	@ResponseBody
	@PostMapping( "/sprints/active/tasks" )
	public List<TaskDto> generateActiveSprintReport( @RequestBody SprintReportRequestDto dto, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		return projectReportService.generateActiveSprintReport( dto, token );
	}
}