package com.pluck.dto;

import java.util.List;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.springframework.web.multipart.MultipartFile;

import com.pluck.model.Company;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserRequestDTO {

	private Long id;

	private Company company;

	@Size( min = 2, max = 64 )
	@NotBlank
	private String username;

	@Size( max = 255 )
	private String status;

	private List<String> role;

	private Long projectId;

	@Size( min = 2, max = 16 )
	@NotBlank
	private String firstName;

	@Size( min = 2, max = 24 )
	@NotBlank
	private String lastName;

	@Size( min = 2, max = 50 )
	private String middleName;

	@Size( max = 32 )
	private String jobTitle;

	@Size( max = 64 )
	private String alternateEmailId;

	// @Size( max = 4 )
	// @NotBlank
	private String countryCode;

	@Size( min = 10, max = 16 )
	@NotBlank
	private String contactNumber;

	private String password;

	private MultipartFile profilePicFile;
	
	private String imagePath;
}
