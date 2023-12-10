package com.pluck.utilites;

import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.pluck.dto.LoginUserDto;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.project.ProjectRequestDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.user.UserDropdownResponseDto;

import jakarta.servlet.http.HttpSession;

@Component
public class ProjectUtilities {

	@Autowired
	private Environment env;

	public List<ProjectDropdownResponseDto> getProjectDropdown( HttpSession session, boolean isReload ) {

		LoginUserDto loginUser = ( LoginUserDto ) session.getAttribute( "loggedInUser" );
		String token = ( String ) session.getAttribute( "token" );
		RestTemplate template = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept( Arrays.asList( MediaType.APPLICATION_JSON ) );
		headers.set( "Authorization", token );
		HttpEntity<String> entity = new HttpEntity<>( "body", headers );

		ParameterizedTypeReference<List<ProjectDropdownResponseDto>> responseType = new ParameterizedTypeReference<List<ProjectDropdownResponseDto>>() {
		};

		ResponseEntity<List<ProjectDropdownResponseDto>> result = template.exchange( env.getProperty( "api.project.DropDown" ) + loginUser.getCompanyId() + "/" + loginUser.getId(), HttpMethod.GET, entity, responseType );
		return result.getBody();
	}

	public Set<UserDropdownResponseDto> generateOwnersList( ProjectResponseDto project, List<UserDropdownResponseDto> list ) {
		List<Long> existingOwnerIds = project.getOwners().stream().map( UserDropdownResponseDto::getId ).collect( Collectors.toList() );
		Set<UserDropdownResponseDto> availableOwners = new LinkedHashSet<>();
		for ( int i = 0; i < list.size(); i++ ) {
			if ( !existingOwnerIds.contains( list.get( i ).getId() ) ) {
				availableOwners.add( list.get( i ) );
			}
		}
		return availableOwners;
	}

	public Set<UserDropdownResponseDto> generateUsersList( ProjectResponseDto project, List<UserDropdownResponseDto> userList ) {
		List<Long> existingUserIds = project.getUsers().stream().map( UserDropdownResponseDto::getId ).collect( Collectors.toList() );
		Set<UserDropdownResponseDto> availableUsers = new LinkedHashSet<>();
		for ( int i = 0; i < userList.size(); i++ ) {
			if ( !existingUserIds.contains( userList.get( i ).getId() ) ) {
				availableUsers.add( userList.get( i ) );
			}
		}
		return availableUsers;

	}

	public boolean checkUserAvailabilty( ProjectRequestDto projectRequestDto, Long loggedInUserId ) {
		List<Long> owners = projectRequestDto.getOwners();
		List<Long> users = projectRequestDto.getUsers();
		if ( owners != null && owners.contains( loggedInUserId ) ) {
			return true;
		}
		if ( users != null && users.contains( loggedInUserId ) )
			return true;
		return false;
	}

	public boolean checkUserAvailabilty( List<UserDropdownResponseDto> users, Long loggedInUserId ) {

		List<Long> userIds = users.stream().map( UserDropdownResponseDto::getId ).collect( Collectors.toList() );
		if ( userIds.contains( loggedInUserId ) )
			return true;
		return false;
	}

}
