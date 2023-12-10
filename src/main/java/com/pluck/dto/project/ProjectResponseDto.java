package com.pluck.dto.project;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.pluck.dto.user.UserDropdownResponseDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProjectResponseDto {

	private Long id;
	private String name;
	private String description;
	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate startDate;
	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate lastDate;
	private String status;
	private List<UserDropdownResponseDto> owners;
	private List<UserDropdownResponseDto> users;
	private boolean editAcces = true;

}
