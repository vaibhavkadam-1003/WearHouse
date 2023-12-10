package com.pluck.controller;

import java.time.LocalDateTime;
import java.util.List;

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
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.UserResponseDTO;
import com.pluck.dto.task.CommentAttachmentResponseDto;
import com.pluck.dto.task.TaskCommentDto;
import com.pluck.dto.task.TaskCommentResponseDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.TaskCommentService;
import com.pluck.service.UserService;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/comment" )
@Controller
@AllArgsConstructor
public class TaskCommentController {

	private final TaskCommentService service;
	private final UserService userService;
	private final TaskCommentService taskCommentService;

	@PostMapping( "/addTaskComment" )
	@ResponseBody
	public TaskCommentResponseDto add( @ModelAttribute TaskCommentDto taskCommentDto, HttpSession session, RedirectAttributes ra, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		taskCommentDto.setAddedBy( loggedInUser.getId() );
		taskCommentDto.setCompanyId( loggedInUser.getCompanyId() );
		TaskCommentResponseDto response = service.addTaskComment( taskCommentDto, token );
		UserResponseDTO user = userService.findByid( response.getAddedBy(), token );
		response.setFirstName( user.getFirstName() );
		response.setLastName( user.getLastName() );
		return response;

	}

	@GetMapping( "/delete/{commentId}" )
	@ResponseBody
	public String deleteTaskComment( @PathVariable Long commentId, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		return service.deleteTaskComment( commentId, token, loggedInUser.getCompanyId(), loggedInUser.getId() );
	}

	@PostMapping( "/update" )
	@ResponseBody
	public TaskCommentResponseDto updateTaskComment( @ModelAttribute TaskCommentDto dto, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setAddedBy( loggedInUser.getId() );
		dto.setUpdatedBy( loggedInUser.getId() );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		dto.setAddedOn( LocalDateTime.parse( dto.getDateTimeString() ) );
		TaskCommentResponseDto response = service.updateTaskComment( dto, token );
		UserResponseDTO user = userService.findByid( response.getAddedBy(), token );
		response.setFirstName( user.getFirstName() );
		response.setLastName( user.getLastName() );
		return response;
	}

	@ResponseBody
	@GetMapping( "/attachment/{commentId}/{taskId}" )
	public List<CommentAttachmentResponseDto> getCommentAttachment( @PathVariable Long commentId, @PathVariable Long taskId, HttpSession session, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		List<CommentAttachmentResponseDto> commentAttachment = taskCommentService.findAttachmentById( token, commentId );
		model.addAttribute( "commentAttachmentList", commentAttachment );
		return commentAttachment;
	}

	@GetMapping( "/delete/file/{id}" )
	@ResponseBody
	public String deleteCommentFile( @RequestParam( "id" ) Long id, TaskDto dto, HttpSession session, RedirectAttributes ra, Model model ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		service.deleteCommentFile( token, id );
		return "File deleted";
	}

}
