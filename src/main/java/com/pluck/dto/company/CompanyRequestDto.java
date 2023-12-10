package com.pluck.dto.company;

import com.pluck.dto.user.UserRequestDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CompanyRequestDto {
	private CompanyDto company;

	private UserRequestDto admin;

}
