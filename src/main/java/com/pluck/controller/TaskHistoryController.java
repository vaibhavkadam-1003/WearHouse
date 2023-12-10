package com.pluck.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pluck.constants.Constants;
import com.pluck.dto.task.TaskHistoryResponseDto;
import com.pluck.service.TaskHistoryService;

import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@RequestMapping( "/taskHistory" )
@Controller
@AllArgsConstructor
public class TaskHistoryController {

	private final TaskHistoryService service;

	@ResponseBody
	@GetMapping( "/{taskId}" )
	public List<TaskHistoryResponseDto> getTaskHistory( @PathVariable Long taskId, HttpSession session ) {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		return service.getTaskHistory( taskId, token );
	}
}
