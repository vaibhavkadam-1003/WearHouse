package com.pluck.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.dropdown.PriorityConfigurationDto;
import com.pluck.dto.dropdown.SeverityConfigurationDto;
import com.pluck.dto.dropdown.StatusConfigurationDto;
import com.pluck.dto.query.QueryBuilderTaskResponseDto;
import com.pluck.dto.query.QueryDto;
import com.pluck.service.ProjectService;
import com.pluck.service.QueryService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping( "/queries" )
public class QueryController {

	@Autowired
	private QueryService queryService;

	@Autowired
	private DropdownCache dropdownCache;

	@Autowired
	private ProjectService projectService;

	@ResponseBody
	@PostMapping
	public List<QueryBuilderTaskResponseDto> query( @ModelAttribute QueryDto dto, HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		return queryService.query( dto, defaultProjectId );
	}

	@ResponseBody
	@GetMapping( "/priorities" )
	public List<String> priorities( HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		List<PriorityConfigurationDto> list = dropdownCache.getPriorities( defaultProjectId );
		List<String> priorities = new ArrayList<>();
		for ( PriorityConfigurationDto dto : list ) {
			priorities.add( dto.getPriority() );
		}
		return priorities;
	}

	@ResponseBody
	@GetMapping( "/status" )
	public List<String> status( HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		List<StatusConfigurationDto> list = dropdownCache.getStatuses( defaultProjectId );
		List<String> statusList = new ArrayList<>();
		for ( StatusConfigurationDto dto : list ) {
			statusList.add( dto.getStatus() );
		}
		return statusList;
	}

	@ResponseBody
	@GetMapping( "/severities" )
	public List<String> severities( HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		List<SeverityConfigurationDto> list = dropdownCache.getSeverities( defaultProjectId );
		List<String> severitiyList = new ArrayList<>();
		for ( SeverityConfigurationDto dto : list ) {
			severitiyList.add( dto.getSeverity() );
		}
		return severitiyList;
	}

	@ResponseBody
	@GetMapping( "/assignees" )
	public Set<UserResponseDTO> assingees( HttpSession session ) {
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long companyId = loggedInUser.getCompanyId();
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return projectService.allUsersByProject( defaultProjectId, companyId, token, 0 );
	}
}
