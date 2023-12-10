package com.pluck.dto.project;

import com.pluck.dto.user.UserDropdownResponseDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProjectUserMappingResponseDto {
	private Long companyId;
	private Long userId;
	private UserDropdownResponseDto user;
	private Long projectId;

	private String role;
}
