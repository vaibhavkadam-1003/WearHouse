package com.pluck.dto.user;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SignUpRequestDto {

	private long companyId;

	@Size( min = 2, max = 50 )
	@NotBlank
	private String firstName;

	@Size( min = 2, max = 50 )
	@NotBlank
	private String lastName;

	@Size( max = 50 )
	@NotBlank
	private String username;

	private String countryCode;

	@Size( max = 20 )
	@NotBlank
	private String contactNumber;

}
