package com.pluck.service;

import java.util.List;

import com.pluck.dto.task.ModuleDto;

public interface ModuleService {
	public ModuleDto add( ModuleDto dto, Long projectId, Long companyId, String token );

	public List<ModuleDto> findAll( Long projectId, Long companyId, String token );

	public String update( ModuleDto dto, String token );

	public ModuleDto findById( Integer id, String token );

	public int deleteById( Integer id, String token );
}
