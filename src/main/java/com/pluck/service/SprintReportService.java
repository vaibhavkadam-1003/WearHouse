package com.pluck.service;

import java.util.List;

import com.pluck.dto.sprint.SprintUserChartDetailsDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;

public interface SprintReportService {

	List<SprintUserChartDetailsDto> currentSprintUserReport(Long companyId, Long defaultProjectId, Integer currentSprint, String token);

	List<TaskDto> findCompletedTasksBySprint(String token, Long companyId, Long defaultProjectId,
			Integer currentSprint);

	List<TaskDto> findInCompletedTasksBySprint(String token, Long companyId, Long defaultProjectId,
			Integer currentSprint);

	List<SprintDto> findAllSprintsByCompanyAndProject(String token, Long companyId, Long defaultProjectId);

	String findBySprintNameById(Integer selectedSprint, String token);

	Integer countByTotalTasks(Long companyId, Long defaultProjectId, Integer selectedSprint, String token);

	Integer countAllCompletedTasks(Long companyId, Long defaultProjectId, Integer selectedSprint, String token);

}
