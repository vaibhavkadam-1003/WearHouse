package com.pluck.model;

import java.time.LocalDate;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class User {
	private Long id;

	private Company company;

	private String username;

	private String status;

	private String role;

	private String firstName;

	private String lastName;

	private String middleName;

	private String jobTitle;

	private String alternateEmailId;

	private String countryCode;

	private String contactNumber;

	private String password;

	private String profilePic;

	private User addedBy;

	private LocalDate addedOn;

	private User updatedBy;

	private LocalDate updatedOn;

	private MultipartFile profilePicFile;

}
