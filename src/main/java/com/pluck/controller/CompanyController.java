package com.pluck.controller;

import java.net.URISyntaxException;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.company.CompanyDetailsResponseDto;
import com.pluck.dto.company.CompanyPageDto;
import com.pluck.dto.company.CompanyRequestDto;
import com.pluck.dto.company.CompanyResponseDTO;
import com.pluck.dto.company.Content;
import com.pluck.service.CompanyService;
import com.pluck.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/company" )
@Controller
@AllArgsConstructor
public class CompanyController {

	private final CompanyService companyService;
	private final NotificationService notificationService;

	@GetMapping( "/add/form" )
	public String addForm( HttpSession session, Model model ) {
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "companies/add";
	}

	@PostMapping
	public String add( @ModelAttribute CompanyRequestDto company, HttpSession session, RedirectAttributes ra ) {
		String isAdded = companyService.add( company, ( String ) session.getAttribute( Constants.TOKEN ) );
		if ( Constants.ADD_COMPANY_SUCCESS.equals( isAdded ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isAdded );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, isAdded );

		return "redirect:/company?pageNo=0";
	}

	@GetMapping( "/update/form/{id}" )
	public String getUpdateCompanyForm( @PathVariable( value = "id" ) long id, Model model, HttpSession session ) {

		CompanyResponseDTO company = companyService.findByid( id, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( "company", company );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );
		return "companies/update";

	}

	@PostMapping( "/update" )
	public String update( @ModelAttribute CompanyRequestDto companyRequestDto, HttpSession session, RedirectAttributes ra ) {
		String isUpdated = companyService.update( companyRequestDto, ( String ) session.getAttribute( Constants.TOKEN ) );
		ra.addFlashAttribute( "message", isUpdated );
		if ( Constants.UPDATE_COMPANY_SUCCESS.equals( isUpdated ) )
			ra.addFlashAttribute( Constants.SUCCESS_MESSAGE, isUpdated );
		else
			ra.addFlashAttribute( Constants.ERROR_MESSAGE, isUpdated );
		return "redirect:/company?pageNo=0";
	}

	@GetMapping
	public String allUsers( Model model, HttpSession session, @ModelAttribute( "message" ) String message, @RequestParam int pageNo ) throws URISyntaxException {
		CompanyPageDto list = companyService.findAll( ( String ) session.getAttribute( "token" ), pageNo );

		List<Content> companies = list.getContent();
		Collections.sort(companies, (c1, c2) -> c1.getName().compareToIgnoreCase(c2.getName()));

		CompanyPageDto sortedCompanyPage = new CompanyPageDto();
		sortedCompanyPage.setContent( companies );

		model.addAttribute( "list", sortedCompanyPage );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( "token" ) ) );
		return "companies/allCompany";
	}

	@GetMapping( "/details/{id}" )
	public String companyDetails( @PathVariable Long id, HttpSession session, Model model ) {
		CompanyDetailsResponseDto dto = companyService.getCompanyDetails( id, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( "data", dto );

		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		model.addAttribute( Constants.NOTIFICATIONS, notificationService.getNotification( loggedInUser.getCompanyId(),
				loggedInUser.getId(), ( String ) session.getAttribute( Constants.TOKEN ) ) );

		return "companies/companyDetails";
	}

}
