package com.pluck.model;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Company {
	private Long id;

	private String name;

	private String shortName;

	private String status;

	private String countryCodeForWorkPhone;

	private String workPhone;

	private String countryCodeForAlternatePhone;

	private String alternatePhone;

	private String emailId;

	private String alternateMailId;

	private String website;

	private String subscriptionPlan;

	private Integer maxUsers;

	private LocalDate addedOn;

	private LocalDate updatedOn;

	private User addedBy;

	private User updatedBy;

	private String subscriptionType;

	private Integer subscriptionRate;

}
