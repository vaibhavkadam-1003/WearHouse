package com.pluck.service;

import java.util.List;

import com.pluck.dto.task.AcceptanceCriteriaDto;

public interface AcceptanceCriteriaService {
	public AcceptanceCriteriaDto add( AcceptanceCriteriaDto dto, String token, Long companyId, Long defaultProjectId );

	public List<AcceptanceCriteriaDto> findAll( Long projectId, Long companyId, String token );
}
