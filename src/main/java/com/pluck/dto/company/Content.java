package com.pluck.dto.company;

import java.time.LocalDate;


import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Content {

	@JsonDeserialize(using = LocalDateDeserializer.class)
	@JsonSerialize(using = LocalDateSerializer.class)
	private LocalDate addedOn;

	@JsonDeserialize(using = LocalDateDeserializer.class)
	@JsonSerialize(using = LocalDateSerializer.class)
	private LocalDate updatedOn;

	public String addedByUser;
	public String updatedByUser;
	public int id;
	public String name;
	public String shortName;
	public String status;
	public String countryCodeForWorkPhone;
	public String workPhone;
	public String countryCodeForAlternatePhone;
	public String alternatePhone;
	public String emailId;
	public String alternateMailId;
	public String website;
	public String subscriptionPlan;
	public int maxUsers;
	public String subscriptionType;
	public int subscriptionRate;
}
