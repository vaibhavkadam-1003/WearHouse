package com.pluck.service;

import java.util.List;
import java.util.Map;

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.scrum.ScrumTeamResponseDto;

public interface ProjectManagerService {

	Map<String, List<ScrumTeamResponseDto>> findAllScrumTeamsByProjectManager( Long companyId, Long projectManagerId, String token );

	List<UserResponseDTO> findScrumMastersByProjectManager( Long companyId, Long id, String token );

}
