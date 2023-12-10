
package com.pluck.controller;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Objects;
import java.util.Set;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.constants.ViewConstants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.RoleDto;
import com.pluck.dto.UserRequestDTO;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.project.ProjectDropdownResponseDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.user.UserPagerDto;
import com.pluck.service.NotificationService;
import com.pluck.service.ProjectService;
import com.pluck.service.UserService;
import com.pluck.utilites.ProjectUtilities;
import com.pluck.utilites.UserUtilities;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RequestMapping( "/users" )
@Controller
@RequiredArgsConstructor
public class UserController {

	private final UserService userService;
	private final ProjectService projectService;
	private final ProjectUtilities projectUtilities;
	private final NotificationService notificationService;
	private final UserUtilities userUtilities;

	@Value( "${image.file.path}" )
	private String imagePath;

	@GetMapping( "/add/form" )
	public String getAddUserForm( HttpSession session, Model model ) {

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		List<RoleDto> lowerRoles = userUtilities.getLowerRolesList( ( int ) session.getAttribute( "highestRoleValue" ), null );
		model.addAttribute( "LowerRoles", lowerRoles );

		return "users/add";
	}

	@PostMapping
	public String add( @ModelAttribute UserRequestDTO userRequestDTO, HttpSession session, Model model,
			RedirectAttributes ra ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		userRequestDTO.setProjectId( defaultProjectId );
		userRequestDTO.setImagePath( imagePath );
		String isAdded = userService.add( userRequestDTO, ( String ) session.getAttribute( Constants.TOKEN ) );
		if ( Constants.ADD_USER_SUCCESS.equals( isAdded ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isAdded );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, isAdded );

		return "redirect:/users?pageNo=0";
	}

	@GetMapping( "/update/form/{id}" )
	public String getUpdateUserForm( @PathVariable( value = "id" ) long id, Model model, HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		UserResponseDTO user = null;
		if ( defaultProjectId == null ) {
			user = userService.findByid( id, ( String ) session.getAttribute( Constants.TOKEN ) );
		} else {
			user = userService.findByidAndProject( id, defaultProjectId, ( String ) session.getAttribute( Constants.TOKEN ) );
		}
		model.addAttribute( "user", user );
		List<RoleDto> assingedRoles = userUtilities.getAssignedRoles( user.getRole() );
		//List<RoleDto> remainingRoles = userUtilities.getRemainingRoles( user.getRole() );
		List<RoleDto> remainingRoles = userUtilities.getLowerRolesList( ( int ) session.getAttribute( "highestRoleValue" ), user.getRole() );

		model.addAttribute( "assingedRoles", assingedRoles );
		model.addAttribute( "remainingRoles", remainingRoles );
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "users/update";

	}

	@PostMapping( "/update" )
	public String update( @ModelAttribute UserRequestDTO userRequestDTO, HttpSession session, Model model, RedirectAttributes ra ) throws URISyntaxException {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		userRequestDTO.setProjectId( defaultProjectId );
		userRequestDTO.setImagePath( imagePath );
		String isUpdated = userService.update( userRequestDTO, ( String ) session.getAttribute( Constants.TOKEN ) );
		if ( isUpdated.equals( Constants.UPDATE_USER_SUCCESS ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isUpdated );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, isUpdated );
		LoginUserDto loggedInuser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		if ( loggedInuser.getId().equals( userRequestDTO.getId() ) ) {
			loggedInuser.setFirstName( userRequestDTO.getFirstName() );
			loggedInuser.setLastName( userRequestDTO.getLastName() );
			model.addAttribute( Constants.LOGGED_IN_USER, loggedInuser );
		}
		UserPagerDto list = userService.findAll( ( String ) session.getAttribute( Constants.TOKEN ), loggedInuser.getCompanyId(), 0 );
		model.addAttribute( "list", list );

		UserResponseDTO dto = userService.findByid( userRequestDTO.getId(), ( String ) session.getAttribute( Constants.TOKEN ) );
		if ( loggedInuser.getId().equals( userRequestDTO.getId() ) ) {
			if ( dto.getProfilePic() != "" ) {
				loggedInuser.setProfilePic( dto.getProfilePic() );
			}
		}

		if ( loggedInuser.getRole().get( 0 ).equals( Constants.SUPER_ADMIN ) )
			return ViewConstants.ALL_COMPANY;
		return ViewConstants.ALL_USERS;
	}

	@GetMapping
	public String allUsers( Model model, HttpSession session, @ModelAttribute( "message" ) String message, @RequestParam int pageNo ) throws URISyntaxException {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		UserPagerDto list = userService.findAll( ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser.getCompanyId(), pageNo );
		UserPagerDto list1 = userService.setEditableFlagAllUser( list, ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser, ( String ) session.getAttribute( "role" ) );
		model.addAttribute( "userList", list1 );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );

		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "users/allUsers";
	}

	@GetMapping( "/getUsersByStatus" )
	@ResponseBody
	public UserPagerDto getAllUsersByStatus( Model model, HttpSession session, @ModelAttribute( "message" ) String message, @RequestParam int pageNo, @RequestParam String status ) throws URISyntaxException {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		UserPagerDto list = userService.findAllByStatus( ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser.getCompanyId(), status, pageNo );
		return userService.setEditableFlagAllUser( list, ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser, ( String ) session.getAttribute( "role" ) );
	}

	@GetMapping( "/getUsersProject" )
	public String allUsersByProject( Model model, HttpSession session, @RequestParam int pageNo ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );

		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		if ( defaultProjectId == null ) {
			model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
					loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		} else {
			ProjectResponseDto project = projectService.findById( defaultProjectId, ( String ) session.getAttribute( Constants.TOKEN ) );

			boolean isLoggedInOwnerPresent = projectUtilities.checkUserAvailabilty( project.getOwners(), loggedInUser.getId() );
			boolean isLoggedInUserPresent = projectUtilities.checkUserAvailabilty( project.getUsers(), loggedInUser.getId() );

			if ( isLoggedInOwnerPresent || isLoggedInUserPresent && Objects.equals( defaultProjectId, project.getId() ) ) {
				List<ProjectDropdownResponseDto> projects = projectUtilities.getProjectDropdown( session, true );
				if ( !projects.isEmpty() ) {
					long companyId = loggedInUser.getCompanyId();

					Set<UserResponseDTO> list = projectService.allUsersByProject( defaultProjectId, companyId, ( String ) session.getAttribute( Constants.TOKEN ), pageNo );
					Set<UserResponseDTO> list1 = userService.setEditableFlag( list, defaultProjectId, ( String ) session.getAttribute( Constants.TOKEN ), loggedInUser, ( String ) session.getAttribute( "role" ) );
					model.addAttribute( "userListByProject", list1 );

					model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, true ) );

					model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
							loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
				} else {
					session.setAttribute( "currentSprint", null );
					session.setAttribute( Constants.DEFAULT_PROJECT_ID, null );
					session.setAttribute( "defaultProjectName", null );
				}
			}

		}
		return ViewConstants.PROJECT_USERS;
	}

	@GetMapping( "/getUserForm" )
	public String getUserForm() {
		return "users/selectById";
	}

	@ResponseBody
	@GetMapping( "/deleteUserProfile/{userId}" )
	public String deleteProfileLogo( @PathVariable Long userId, HttpSession session, RedirectAttributes ra ) {

		long deleteUserProfile = userService.deleteProfileLogo( userId, ( String ) session.getAttribute( Constants.TOKEN ) );

		if ( deleteUserProfile > 0 ) {
			LoginUserDto loggedInuser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
			if ( loggedInuser.getId().equals( userId ) ) {
				loggedInuser.setProfilePic( "" );
			}
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, Constants.DELETE_PROFILE_SUCCESS );
			return "success";
		} else {
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, Constants.DELETE_PROFILE_ERROR );
			return "error";
		}
	}
}
