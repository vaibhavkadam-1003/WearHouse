package com.pluck.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pluck.constants.Constants;
import com.pluck.dto.smtp.SmtpDto;
import com.pluck.service.SmtpService;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/smtp" )
@Controller
@AllArgsConstructor
public class SmtpController {

	private SmtpService smtpService;

	@GetMapping( "/add/smtp" )
	public String addSmtp() {
		return "companies/addSmtp";
	}

	@PostMapping
	public String save( SmtpDto smtpDto, Model model, HttpSession session ) {
		smtpService.save( smtpDto, ( String ) session.getAttribute( Constants.TOKEN ) );
		return "redirect:/smtp/all/smtp";
	}

	@GetMapping( "/all/smtp" )
	public String getAllSmtp( Model model, HttpSession session ) {
		List<SmtpDto> list = smtpService.findAllSmtp( ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( "smtp", list );
		return "companies/allSmtp";
	}

	@GetMapping( "/update/form/{id}" )
	public String getSmtp( @PathVariable( value = "id" ) long id, Model model, HttpSession session ) {
		SmtpDto smtp = smtpService.findSmtp( id, ( String ) session.getAttribute( Constants.TOKEN ) );
		model.addAttribute( "smtp", smtp );
		return "companies/addSmtp";
	}
}
