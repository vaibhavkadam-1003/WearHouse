package com.pluck.service;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectPagerDto;
import com.pluck.dto.project.ProjectRequestDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.project.ProjectUserRequestDto;
import com.pluck.dto.user.UserDropdownResponseDto;

public interface ProjectService {

	public ProjectResponseDto addProject( ProjectRequestDto dto, LoginUserDto loginUserDto, String token );

	public List<UserDropdownResponseDto> getUsersDropdown( String token );

	public ProjectResponseDto findById( Long id, String token );

	public ProjectResponseDto updateProject( ProjectRequestDto projectRequestDto, LoginUserDto loginUserDto, String token );

	ProjectPagerDto findAll( LoginUserDto loggingUser, String token, int pageNo ) throws URISyntaxException;

	public String removeUser( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token );

	public String removeOwner( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token );

	public String addOwner( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token );

	public String addUser( ProjectUserRequestDto projectUserRequestDto, LoginUserDto loginUserDto, String token );

	Set<UserResponseDTO> allUsersByProject( Long defaultProjectId, Long companyId, String token, int pageNo );

	List<ProjectResponseDto> scrumMasterProject( Long id, long companyId, String token );

	public int countByCompanyIdAndName( Long companyId, String name, String token );

	public List<ProjectResponseDto> topFiveProjectsByUser( String token, Long loggedInUserId, Long companyId );

	public ProjectPagerDto getAllProjectsByUser( String token, Long id, Long companyId, int pageNo );

	public int countAllprojectByCompany( Long companyId, String token );

	public void reloadRoleConfiguration( Long project, String token );

	public Map<String, Integer> findTaskCountForProject( Long companyId, Long project, String token );

}
