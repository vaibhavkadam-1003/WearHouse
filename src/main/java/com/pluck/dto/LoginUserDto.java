package com.pluck.dto;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
public class LoginUserDto implements Serializable {

	private Long id;
	private String userName;
	private Long companyId;
	private LocalDateTime tokenResetTime;
	private Integer maxUsers;
	private List<String> role;
	private String highestRole;
	private String firstName;
	private String lastName;
	private String profilePic;
}
