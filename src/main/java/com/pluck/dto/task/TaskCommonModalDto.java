package com.pluck.dto.task;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import org.springframework.web.multipart.MultipartFile;

import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.user.UserDropdownResponseDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskCommonModalDto {
	private List<UserResponseDTO> otherUsers;
	private List<UserResponseDTO> scrumUsers;
	private Set<UserResponseDTO> lists;
	private List<TaskCommentResponseDto> allComment;
	private List<UserDropdownResponseDto> users;
	private List<String> taskType;
	private List<PriorityConfigurationDto> priorities;
	private List<SeverityConfigurationDto> severties;
	private List<StatusConfigurationDto> taskStatus;
	private TaskDto task;
	private List<SprintDto> sprints;
	private List<StoryPointConfigurationDto> taskStoryPoint;
	private List<ProjectDropdownResponseDto> projectList;
}
