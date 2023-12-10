package com.pluck.dto.company;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CompanyAdminShortDto {
	private int id;
	private String firstName;
	private String lastName;
	private String username;
	private String role;
	private String contactNumber;
}