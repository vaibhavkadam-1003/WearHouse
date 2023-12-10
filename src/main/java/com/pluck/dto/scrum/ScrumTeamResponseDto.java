package com.pluck.dto.scrum;

import java.util.List;

import com.pluck.dto.UserResponseDTO;
import com.pluck.model.Project;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ScrumTeamResponseDto {
	private Long id;
	private String name;
	private int members;
	private Project project;
	private List<UserResponseDTO> users;
}
