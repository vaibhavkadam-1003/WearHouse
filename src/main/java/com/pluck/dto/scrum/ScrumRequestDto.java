package com.pluck.dto.scrum;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScrumRequestDto {
	private Long id;
	private String name;
	private int members;
	private Long projectId;
	private Long companyId;
	private Long scrumMasterId;
	private Long projectManagerId;
	private List<Long> users;
	private List<ScrumUserRoleDto> roles;

}
