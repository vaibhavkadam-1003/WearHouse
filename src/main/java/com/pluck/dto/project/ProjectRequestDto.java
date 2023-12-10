package com.pluck.dto.project;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.pluck.dto.LoginUserDto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProjectRequestDto {

	private Long id;
	private String name;
	private String description;
	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate startDate;
	@DateTimeFormat( pattern = "yyyy-MM-dd" )
	private LocalDate lastDate;
	private String status;
	private String logo;
	private List<Long> owners;
	private List<Long> users;
	private MultipartFile file;
	private LoginUserDto loginUserDto;


}
