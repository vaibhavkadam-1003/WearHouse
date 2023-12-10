package com.pluck.service;

import com.pluck.dto.task.DetailedUserStoryRequestDto;
import com.pluck.dto.task.DetailedUserStoryResponseDto;
import com.pluck.dto.task.QuickStoryPaginationResponse;
import com.pluck.dto.task.QuickUserStoryRequestDto;

public interface UserStoryService {

	public String addQuickStory( QuickUserStoryRequestDto dto, String token, Long companyId, Long defaultProjectId );

	public String addDetailedStory( DetailedUserStoryRequestDto dto, String token, Long companyId, Long defaultProjectId, String firstName, String lastName, Long loggedInUserId );

	public QuickStoryPaginationResponse allUserStories( String token, int pageNo, Long companyId, Long projectId );

	public DetailedUserStoryResponseDto findUserStoryById( String token, Long storyId, Long companyId );

	public String updateQuickStory( QuickUserStoryRequestDto dto, String token, Long companyId, Long defaultProjectId );
	
	public int getUserStoryCount(String token, Long companyId, Long defaultProjectId);

	public int countAllStoryByCompany(Long companyId, String token);
}
