package com.pluck.dto.project;

import java.util.List;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.scrum.ScrumUserRoleDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProjectUserRequestDto {

	private Long id;

	private Long[] users;

	private LoginUserDto loginUserDto;

	private List<ScrumUserRoleDto> roles;
}
