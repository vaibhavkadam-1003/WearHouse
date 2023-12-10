package com.pluck.dto.user;

import javax.validation.constraints.NotBlank;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChangePasswordDto {

	@NotBlank
	private String newPassword;

	@NotBlank
	private String oldPassword;
}
