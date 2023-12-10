package com.pluck.service;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Set;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserRequestDTO;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.user.InvalidTokenDto;
import com.pluck.dto.user.UserPagerDto;

public interface UserService {

	public UserPagerDto findAll( String token, Long companyId, int pageNo ) throws URISyntaxException;

	public UserPagerDto findAllByStatus( String token, Long companyId, String status, int pageNo ) throws URISyntaxException;

	public UserResponseDTO findByid( Long id, String token );

	public UserResponseDTO findByidAndProject( Long id, Long projectId, String token );

	public String add( UserRequestDTO userRequestDTO, String token );

	public String update( UserRequestDTO userRequestDTO, String attribute );

	public int countAllUsersByCompany( Long companyId, String token );

	public long deleteProfileLogo( Long userId, String token );

	public Set<UserResponseDTO> setEditableFlag( Set<UserResponseDTO> list, Long defaultProjectId, String token, LoginUserDto loginUserDto, String currentRole );

	public UserPagerDto setEditableFlagAllUser( UserPagerDto list, String attribute, LoginUserDto loggedInUser, String attribute2 );

	public List<InvalidTokenDto> getInvalidTokens( String username, Long userId, String token );

	public String saveInvalidTokenDtos( InvalidTokenDto invalidTokenDto, String username, Long userId );

}
