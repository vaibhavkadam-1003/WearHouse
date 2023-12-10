package com.pluck.dto.user;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserDropdownResponseDto{

	private Long id;

	private String firstName;

	private String lastName;

	private String username;
	
	private String role;

}
