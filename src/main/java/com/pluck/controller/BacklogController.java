package com.pluck.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.StoryPointConfigurationDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.NotificationService;
import com.pluck.service.SprintService;
import com.pluck.service.TaskService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping( "/backlogs" )
public class BacklogController {

	@Autowired
	private TaskService taskService;

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private SprintService sprintService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private DropdownCache dropdownCache;

	@GetMapping
	public String backlogs( Model model, HttpSession session ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( "defaultProjectId" );

		if ( defaultProjectId == null ) {
			return "redirect:/projects/allproject?pageNo=0";
		}

		String token = ( String ) session.getAttribute( "token" );
		model.addAttribute( "projectList", projectUtilities.getProjectDropdown( session, false ) );

		List<StoryPointConfigurationDto> storyPointList = dropdownCache.getStoryPoints( defaultProjectId );

		if ( storyPointList == null ) {
			dropdownCache.loadStoryPoints( loggedInUser.getCompanyId(), token );
			storyPointList = dropdownCache.getStoryPoints( defaultProjectId );
		}

		final Map<String, Integer> storyPointsFromDB = new HashMap<>();

		if ( storyPointList != null && !storyPointList.isEmpty() ) {
			storyPointsFromDB.putAll(
					storyPointList.stream()
							.collect( Collectors.toMap(
									StoryPointConfigurationDto::getStoryPoint,
									StoryPointConfigurationDto::getRange,
									( existingRange, newRange ) -> existingRange
							) ) );
		}

		List<TaskDto> backlogTask = taskService.findAllBacklogTasks( token, loggedInUser.getCompanyId(), defaultProjectId );
		int pendingStoryPoints = 0;

		if ( backlogTask != null ) {
			List<TaskDto> backlogTasks = backlogTask.stream().filter( task -> task.getSprint() == 0 ).collect( Collectors.toList() );

			if ( backlogTasks != null ) {
				pendingStoryPoints = backlogTasks.stream().mapToInt( bl -> storyPointsFromDB.containsKey( bl.getStory_point() ) ? storyPointsFromDB.get( bl.getStory_point() ) : 0 ).sum();
			}
			model.addAttribute( "backlogs", backlogTasks );
		}

		model.addAttribute( "pendingStoryPoints", pendingStoryPoints );

		List<TaskDto> tasks = taskService.getAllIncompleteTasks( token, loggedInUser.getCompanyId(), defaultProjectId );
		List<SprintDto> activeSprints = sprintService.findBacklogActiveSprints( token, loggedInUser.getCompanyId(), defaultProjectId );

		if ( activeSprints != null ) {

			List<Map<String, Object>> sprintList = new ArrayList<>();

			for ( SprintDto sprint : activeSprints ) {
				Map<String, Object> sprintData = new HashMap<>();
				sprintData.put( "sprintId", sprint.getId() );
				sprintData.put( "sprintName", sprint.getName() );

				List<TaskDto> sprintTasks = tasks.stream().filter( task -> task.getSprint() == sprint.getId() ).collect( Collectors.toList() );
				sprintData.put( "currentSprintTasks", sprintTasks );

				int currentSprintTotalStoryPoints = sprintTasks.stream().mapToInt( task -> storyPointsFromDB.containsKey( task.getStory_point() ) ? storyPointsFromDB.get( task.getStory_point() ) : 0 ).sum();
				sprintData.put( "currentSprintTotalStoryPoints", currentSprintTotalStoryPoints );

				sprintList.add( sprintData );
			}
			model.addAttribute( "sprintDataList", sprintList );
		}
		model.addAttribute( "notifications", notificationService.getNotification( loggedInUser.getCompanyId(), loggedInUser.getId(), ( String ) session.getAttribute( "token" ) ) );

		return "tasks/backlog";
	}
}
