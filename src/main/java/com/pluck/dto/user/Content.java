package com.pluck.dto.user;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Content {

	private Long id;

	@JsonDeserialize( using = LocalDateDeserializer.class )
	@JsonSerialize( using = LocalDateSerializer.class )
	private LocalDate updatedOn;

	@JsonDeserialize( using = LocalDateDeserializer.class )
	@JsonSerialize( using = LocalDateSerializer.class )
	private LocalDate addedOn;

	private String addedByUser;
	private String updatedByUser;
	private String username;
	private String status;
	private List<String> role;
	private String highestRole;
	private String firstName;
	private String lastName;
	private String middleName;
	private Object jobTitle;
	private Object alternateEmailId;
	private String countryCode;
	private String contactNumber;
	private String password;
	private String profilePic;
	private String isEditable;
	private boolean isSharedResource;

}
