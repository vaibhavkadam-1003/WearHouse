package com.pluck.dto.company;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CompanyDetailsResponseDto {
	private CompanyResponseDTO company;
	private List<CompanyAdminShortDto> admins;
}
