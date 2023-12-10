package com.pluck.service;

import java.net.URISyntaxException;

import com.pluck.dto.company.CompanyDetailsResponseDto;
import com.pluck.dto.company.CompanyPageDto;
import com.pluck.dto.company.CompanyRequestDto;
import com.pluck.dto.company.CompanyResponseDTO;

public interface CompanyService {
	String add( CompanyRequestDto dto, String token );

	CompanyPageDto findAll( String token, int pageNo ) throws URISyntaxException;

	CompanyResponseDTO findByid( Long id, String token );

	String update( CompanyRequestDto companyRequestDto, String token );

	CompanyDetailsResponseDto getCompanyDetails( Long id, String token );
}
