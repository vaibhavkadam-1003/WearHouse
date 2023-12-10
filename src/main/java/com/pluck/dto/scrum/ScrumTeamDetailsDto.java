package com.pluck.dto.scrum;

import java.util.List;

import com.pluck.dto.UserResponseDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScrumTeamDetailsDto {
	private Long id;
	private String name;
	private int members;
	private List<UserResponseDTO> users;
}
