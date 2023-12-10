package com.pluck.dto.company;

import javax.validation.constraints.Email;
import javax.validation.constraints.Max;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CompanyDto {
	private Long id;

	@Size( min = 2, max = 64 )
	@NotBlank
	private String name;

	@Size( min = 2, max = 16 )
	private String shortName;

	@Size( max = 255 )
	@NotBlank
	private String status;

	@Size( max = 4 )
	@NotBlank
	private String countryCodeForWorkPhone;

	//@Mobile( optional = true )
	@Size( min = 10, max = 16 )
	@NotBlank
	private String workPhone;

	@Size( max = 4 )
	private String countryCodeForAlternatePhone;

	//@Mobile( optional = true )
	@Size( min = 10, max = 16 )
	private String alternatePhone;

	@Size( min = 2, max = 64 )
	@Email
	@NotBlank
	private String emailId;

	@Size( min = 2, max = 64 )
	private String alternateMailId;

	@Size( min = 2, max = 64 )
	private String website;

	@Size( max = 255 )
	@NotBlank
	private String subscriptionPlan;

	@Max( Integer.MAX_VALUE )
	@NotNull
	private Integer maxUsers;

	@NotNull
	private String subscriptionType;

	private Integer subscriptionRate;

}
