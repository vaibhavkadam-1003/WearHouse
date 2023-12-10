package com.pluck.utilites;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.pluck.dto.RoleDto;

@Component
public class UserUtilities {

	public List<RoleDto> getAssignedRoles( List<String> roleLabels ) {
		List<RoleDto> roles = new ArrayList<>();
		for ( String roleLabel : roleLabels ) {
			RoleDto dto = new RoleDto();
			dto.setLabel( roleLabel );
			dto.setValue( getRoleValue( roleLabel ) );
			dto.setRolePriority(getRolePriority(roleLabel));
			roles.add( dto );
		}
		return roles;
	}

	public List<RoleDto> getRemainingRoles( List<String> roleLabels ) {
		List<String> allRoles = Arrays.asList( "Company Admin", "Project Lead", "Project User", "Scrum Master", "Project Manager" );
		List<String> remainingRoles = allRoles.stream().filter( r -> !roleLabels.contains( r ) ).collect( Collectors.toList() );
		List<RoleDto> roles = new ArrayList<>();
		for ( String roleLabel : remainingRoles ) {
			RoleDto dto = new RoleDto();
			dto.setLabel( roleLabel );
			dto.setValue( getRoleValue( roleLabel ) );
			dto.setRolePriority(getRolePriority(roleLabel));
			roles.add( dto );
		}
		return roles;
	}

	public List<RoleDto> getLowerRolesList(int loginUserHighestRole, List<String> roleLabels){
		List<String> allRoles = Arrays.asList( "Company Admin", "Project Lead", "Project User", "Scrum Master", "Project Manager" );
		if(roleLabels != null) {
			List<String> remainingRoles = allRoles.stream().filter( r -> !roleLabels.contains( r ) ).collect( Collectors.toList() );
			List<RoleDto> roles = new ArrayList<>();
			for(String role : remainingRoles) {
				if(loginUserHighestRole >= getRolePriority(role)) {
					RoleDto dto = new RoleDto();
					dto.setLabel( role );
					dto.setValue( getRoleValue( role ) );
					dto.setRolePriority(getRolePriority(role));
					roles.add( dto );
				}
			}
			return roles;
		}else {
			List<RoleDto> roles = new ArrayList<>();
			for(String role : allRoles) {
				if(loginUserHighestRole >= getRolePriority(role)) {
					RoleDto dto = new RoleDto();
					dto.setLabel( role );
					dto.setValue( getRoleValue( role ) );
					dto.setRolePriority(getRolePriority(role));
					roles.add( dto );
				}
			}
			return roles;
		}
		
	}
	
	private Integer getRoleValue( String role ) {
		switch ( role ) {
		case "Super Admin":
			return 1;
		case "Company Admin":
			return 2;
		case "Project Lead":
			return 3;
		case "Project User":
			return 4;
		case "Scrum Master":
			return 5;
		case "Project Manager":
			return 6;

		default:
			break;
		}
		return 0;
	}
	
	private Integer getRolePriority( String role ) {
		switch ( role ) {
		case "Super Admin":
			return 6;
		case "Company Admin":
			return 5;
		case "Project Lead":
			return 3;
		case "Project User":
			return 1;
		case "Scrum Master":
			return 2;
		case "Project Manager":
			return 4;

		default:
			break;
		}
		return 0;
	}
}
