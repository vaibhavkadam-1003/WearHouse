package com.pluck.dto;

import java.util.List;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import com.pluck.model.Company;
import com.pluck.model.User;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class UserResponseDTO extends AbstractDto<User> {
	private static final long serialVersionUID = 1L;

	private Long id;

	@Size( min = 2, max = 64 )
	@NotBlank
	private String username;

	@Size( max = 255 )
	@NotBlank
	private String status;

	private Company company;

	@Size( max = 255 )
	@NotBlank
	private List<String> role;

	private String highestRole;

	@Size( min = 2, max = 16 )
	@NotBlank
	private String firstName;

	@Size( min = 2, max = 24 )
	@NotBlank
	private String lastName;

	@Size( max = 32 )
	private String middleName;

	@Size( max = 32 )
	private String jobTitle;

	@Size( max = 64 )
	private String alternateEmailId;

	@Size( max = 4 )
	@NotBlank
	private String countryCode;

	@Size( min = 10, max = 16 )
	@NotBlank
	private String contactNumber;

	@Size( max = 64 )
	@NotBlank
	private String password;

	@Size( max = 256 )
	private String profilePic;

	private String isEditable = "true";
	
	private boolean isSharedResource;
}
