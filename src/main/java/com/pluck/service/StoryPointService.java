package com.pluck.service;

import java.util.List;

import com.pluck.dto.task.StoryPointConfigurationDto;

public interface StoryPointService {

	public List<StoryPointConfigurationDto> findAll(String token, Long companyId, Long defaultProjectId);

	public String add(List<StoryPointConfigurationDto> dto, String token, Long companyId, Long defaultProjectId);

}
