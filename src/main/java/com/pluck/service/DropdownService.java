package com.pluck.service;

import java.util.List;

import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;

public interface DropdownService {

	List<PriorityConfigurationDto> savePriority( PriorityConfigurationDto dto, String token, Long companyId, Long defaultProjectId );

	Long delete( Long id, String token );

	List<SeverityConfigurationDto> saveSeverity( SeverityConfigurationDto dto, String token, Long companyId,
			Long defaultProjectId );

	long deleteSeverity( Long id, String token );

	List<StatusConfigurationDto> saveStatus( StatusConfigurationDto dto, String token, Long companyId,
			Long defaultProjectId );

	long deleteStatus( Long id, String token );

}
