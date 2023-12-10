package com.pluck.dto.company;

import javax.validation.constraints.Max;
import javax.validation.constraints.Size;

import com.pluck.dto.AbstractDto;
import com.pluck.model.Company;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CompanyResponseDTO extends AbstractDto<Company> {

	private static final long serialVersionUID = 1L;

	private Long id;

	@Size(max = 64)
	private String name;

	@Size(max = 32)
	private String shortName;

	@Size(max = 255)
	private String status;

	@Size(max = 4)
	private String countryCodeForWorkPhone;

	@Size(max = 64)
	private String workPhone;

	@Size(max = 4)
	private String countryCodeForAlternatePhone;

	@Size(max = 64)
	private String alternatePhone;

	@Size(max = 128)
	private String emailId;

	@Size(max = 128)
	private String alternateMailId;

	@Size(max = 128)
	private String website;

	@Size(max = 255)
	private String subscriptionPlan;

	@Max(Integer.MAX_VALUE)
	private Integer maxUsers;

	private String subscriptionType;

	private Integer subscriptionRate;

}
