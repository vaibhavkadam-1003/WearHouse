package com.pluck.utilites;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.pluck.controller.DropdownCache;
import com.pluck.dto.scrum.ScrumTeamResponseDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.StoryPointConfigurationDto;
import com.pluck.dto.task.TaskDto;

@Component
public class SprintUtility {

	@Autowired
	private DropdownCache dropdownCache;

	public int calculateSprintRemainingDays( SprintDto dto ) {
		LocalDate today = LocalDate.now();

		int totalDaysOfSprint = 0;
		if ( dto.getStartDate() != null && dto.getLastDate() != null )
			totalDaysOfSprint = Period.between( dto.getStartDate(), dto.getLastDate() ).getDays();
		int completedDays = 0;
		if ( dto.getStartDate() != null )
			completedDays = Period.between( dto.getStartDate(), today ).getDays();
		int remianingDays = totalDaysOfSprint - completedDays;
		int remainingWeekdays = 0;
		for ( int i = 1; i <= remianingDays; i++ ) {
			LocalDate date = today.plusDays( i );
			if ( date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY ) {
				remainingWeekdays++;
			}
		}
		return remainingWeekdays;
	}

	public int storyPointPerSprint( Map<String, List<TaskDto>> map, Long defaultProjectId, Long companyId, String token ) {
		int storyPointsPerSprint = 0;
		Map<String, Integer> storyPointsFromDB = new HashMap<>();
		List<StoryPointConfigurationDto> storyPointList = dropdownCache.getStoryPoints( defaultProjectId );

		if ( storyPointList == null || storyPointList.isEmpty() ) {
			dropdownCache.loadStoryPoints( companyId, token );
			storyPointList = dropdownCache.getStoryPoints( defaultProjectId );
		}

		for ( StoryPointConfigurationDto dto : storyPointList ) {
			storyPointsFromDB.put( dto.getStoryPoint(), dto.getRange() );
		}

		for ( Entry<String, List<TaskDto>> entry : map.entrySet() ) {
			List<TaskDto> userTasks = entry.getValue();
			if ( userTasks != null ) {
				for ( TaskDto task : userTasks ) {
					String storyPoint = task.getStory_point();
					if ( storyPoint != null && storyPointsFromDB.containsKey( storyPoint ) ) {
						storyPointsPerSprint += storyPointsFromDB.get( storyPoint );
					}
				}
			}
		}
		return storyPointsPerSprint;
	}

	public int completedStoryPointsPerSprint( Map<String, List<TaskDto>> map, Long defaultProjectId, Long companyId, String token ) {
		Map<String, Integer> storyPointsFromDB = new HashMap<>();
		List<StoryPointConfigurationDto> storyPointList = dropdownCache.getStoryPoints( defaultProjectId );
		if ( storyPointList == null ) {
			dropdownCache.loadStoryPoints( companyId, token );
			storyPointList = dropdownCache.getStoryPoints( defaultProjectId );
		}
		if ( storyPointList.isEmpty() ) {
			dropdownCache.loadStoryPoints( companyId, token );
			storyPointList = dropdownCache.getStoryPoints( defaultProjectId );
		}
		for ( StoryPointConfigurationDto dto : storyPointList ) {
			storyPointsFromDB.put( dto.getStoryPoint(), dto.getRange() );
		}

		int completedStoryPointsPerSprint = 0;

		for ( Entry<String, List<TaskDto>> entry : map.entrySet() ) {
			List<TaskDto> temp = entry.getValue();
			for ( int i = 0; i < temp.size(); i++ ) {
				if ( temp.get( i ).getStatus() != null && temp.get( i ).getStatus().equals( "Resolved" ) )
					completedStoryPointsPerSprint = completedStoryPointsPerSprint + storyPointsFromDB.get( temp.get( i ).getStory_point() );
			}
		}
		return completedStoryPointsPerSprint;
	}

	public Map<String, Integer> generateStatus( Map<String, List<TaskDto>> map, int storyPointsPerSprint, int completedStoryPointsPerSprint, int remianingDays, List<ScrumTeamResponseDto> teams ) {
		int totalTasks = 0;
		int completedTasks = 0;
		int incompleteTasks = 0;
		for ( Entry<String, List<TaskDto>> entry : map.entrySet() ) {
			List<TaskDto> temp = entry.getValue();
			for ( int i = 0; i < temp.size(); i++ ) {
				totalTasks = totalTasks + 1;
				if ( temp.get( i ).getStatus().equals( "Resolved" ) )
					completedTasks = completedTasks + 1;
				else
					incompleteTasks = incompleteTasks + 1;
			}
		}
		Map<String, Integer> data = new HashMap<>();
		data.put( "totalTasks", totalTasks );
		data.put( "completedTasks", completedTasks );
		data.put( "inCompletedTasks", incompleteTasks );
		data.put( "totalStoryPoints", storyPointsPerSprint );
		data.put( "completedStoryPoints", completedStoryPointsPerSprint );
		data.put( "remainingStoryPoints", storyPointsPerSprint - completedStoryPointsPerSprint );
		data.put( "remainingSprintDays", remianingDays );
		if ( teams != null )
			data.put( "teams", teams.size() );
		else
			data.put( "teams", 0 );
		return data;
	}

	public List<ScrumTeamResponseDto> findNewScrumTeams( List<ScrumTeamResponseDto> scrumTeams, List<ScrumTeamResponseDto> alreadyExistedTeams ) {
		if ( alreadyExistedTeams == null )
			return new ArrayList<ScrumTeamResponseDto>();

		List<Long> existingTeamIds = alreadyExistedTeams.stream().map( team -> {
			return team.getId();
		} ).collect( Collectors.toList() );
		List<ScrumTeamResponseDto> list = scrumTeams.stream().filter( team -> !existingTeamIds.contains( team.getId() ) ).collect( Collectors.toList() );
		return list;
	}
}
