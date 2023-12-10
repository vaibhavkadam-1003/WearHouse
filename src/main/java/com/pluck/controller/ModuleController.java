package com.pluck.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.constants.ViewConstants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.task.ModuleDto;
import com.pluck.service.ModuleService;
import com.pluck.service.NotificationService;
import com.pluck.utilites.ProjectUtilities;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping( "/modules" )
public class ModuleController {

	@Autowired
	private ProjectUtilities projectUtilities;

	@Autowired
	private ModuleService moduleService;

	@Autowired
	private NotificationService notificationService;

	@GetMapping( "/addModuleForm" )
	public String addSprintForm( Model model, HttpSession session ) {
		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return ViewConstants.REDIRECT_TO_ALL_MODULE;
	}

	@PostMapping( "/add" )
	@ResponseBody
	public ModuleDto add( @RequestParam String name, HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		ModuleDto dto = new ModuleDto();
		dto.setName( name );

		ModuleDto addModule = moduleService.add( dto, defaultProjectId, loggedInUser.getCompanyId(), token );

		return addModule;
	}

	@GetMapping
	public String allModules( HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );

		List<ModuleDto> moduleList = moduleService.findAll( defaultProjectId, loggedInUser.getCompanyId(), token );

		model.addAttribute( "modules", moduleList );

		model.addAttribute( Constants.PROJECT_LIST, projectUtilities.getProjectDropdown( session, false ) );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "modules/allModules";
	}

	@GetMapping( "/updateModule/{id}" )
	@ResponseBody
	public ResponseEntity<ModuleDto> showUpdateForm( @PathVariable( value = "id" ) Integer id, HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		if ( defaultProjectId != null ) {
			ModuleDto moduleDto = moduleService.findById( id, ( String ) session.getAttribute( Constants.TOKEN ) );
			if ( moduleDto != null ) {
				return ResponseEntity.ok().body( moduleDto );
			} else {
				return ResponseEntity.notFound().build();
			}
		}
		return ResponseEntity.badRequest().build();
	}

	@PutMapping( "/update" )
	@ResponseBody
	public String updateModule( @RequestParam Integer id, @RequestParam String name, HttpSession session, RedirectAttributes ra ) {

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		ModuleDto dto = new ModuleDto();
		dto.setId( id );
		dto.setName( name );
		dto.setCompany( loggedInUser.getCompanyId() );
		dto.setProject( defaultProjectId );
		String addedStatus = moduleService.update( dto, token );
		if ( addedStatus == null ) {
			return null;
		} else {
			return name;
		}
	}

	@DeleteMapping( "/delete/{id}" )
	@ResponseBody
	public String deleteById( @PathVariable( value = "id" ) Integer id, HttpSession session, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		int deletedModule = moduleService.deleteById( id, token );
		if ( deletedModule > 0 )
			return "success";
		else
			return "error";
	}

}
