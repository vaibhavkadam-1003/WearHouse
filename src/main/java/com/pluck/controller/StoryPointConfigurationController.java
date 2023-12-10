package com.pluck.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.task.StoryPointConfigurationDto;
import com.pluck.service.StoryPointService;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/storyPoint" )
@Controller
@AllArgsConstructor
public class StoryPointConfigurationController {

	@Autowired
	private StoryPointService storyPointService;

	@Autowired
	private DropdownCache dropdownCache;

	@GetMapping( "/addStoryForm" )
	public String addForm( Model model, HttpSession session ) {
		return "tasks/addStoryPoint";
	}

	@ResponseBody
	@PostMapping( "/addStoryPoint" )
	public String addDetailedStory( @RequestBody List<StoryPointConfigurationDto> dto, Model model, HttpSession session,
			RedirectAttributes ra ) {

		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		Long defaultProjectId = ( Long ) session.getAttribute( Constants.DEFAULT_PROJECT_ID );

		String addStatus = storyPointService.add( dto, token, loggedInUser.getCompanyId(), defaultProjectId );
		dropdownCache.loadStoryPoints( loggedInUser.getCompanyId(), token );
		ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, addStatus );
		return addStatus;

	}

}
