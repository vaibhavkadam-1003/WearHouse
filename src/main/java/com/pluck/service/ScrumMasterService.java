package com.pluck.service;

import java.util.List;
import java.util.Map;

import com.pluck.dto.report.ProjectCountReport;
import com.pluck.dto.scrum.ScrumTeamResponseDto;

public interface ScrumMasterService {

	Map<String, List<ScrumTeamResponseDto>> findAllScrumTeamsForScrumMaster( Long companyId, Long id, String token );

	Map<String, Integer> findTaskCountForProject( Long companyId, Long defaultProjectId, String token );

	Map<String, Integer> findStoryPointCountForProject( Long companyId, Long projectId, String token );

	ProjectCountReport findCountReportByProject( Long companyId, Long projectId, String token );

	List<ProjectCountReport> findProjectCountReportByScrumMaster( Long companyId, Long id, String token );

	Map<String, List<ScrumTeamResponseDto>> findAllScrumTeamsForUser( Long companyId, Long id, String token );

	Map<String, Integer> findTaskCountForUser( Long companyId, Long projectId, Long selectedUserId, String token );

	Map<String, Integer> findStoryPointCountForUser( Long companyId, Long projectId, Long selectedUserId, String token );

	List<ScrumTeamResponseDto> findAllScrumTeamsForProject( Long companyId, Long project, String token );

}
