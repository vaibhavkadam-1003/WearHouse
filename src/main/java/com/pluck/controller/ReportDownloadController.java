package com.pluck.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pluck.constants.Constants;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.project.ProjectResponseDto;
import com.pluck.dto.report.SprintReportRequestDto;
import com.pluck.dto.report.TaskReportRequestDto;
import com.pluck.dto.task.SprintDto;
import com.pluck.dto.task.TaskDto;
import com.pluck.service.EmailService;
import com.pluck.service.ProjectReportService;
import com.pluck.service.ProjectService;
import com.pluck.service.SprintService;
import com.pluck.utilites.ExcelUtility;
import com.pluck.utilites.PdfUtility;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping( "/report/download" )
@Slf4j
public class ReportDownloadController {

	@Autowired
	private ExcelUtility excelUtility;

	@Autowired
	private ProjectReportService projectReportService;

	@Autowired
	private PdfUtility pdfUtility;

	@Autowired
	private SprintService sprintService;

	@Autowired
	private ProjectService projectService;

	@Autowired
	private EmailService emailService;

	private static final String MSG_SOMETHING_WRONG = "Somtheting went wrong please try again.";

	private static final String REDIRECT_ACTIVE_SPRINT_REPORT_PAGE = "redirect:/reports/sprints/active/getReportPage";

	private static final String REDIRECT_REPORT_PAGE = "redirect:/reports/getReportPage";

	private static final String MSG_NO_RECORDS_FOR_REPORT = "No records to generate report";

	private static final String MSG_NO_ACTIVE_SPRINT = "No active sprint to generate report";

	private static final List<String> headers = Arrays.asList( "Ticket", "Title", "Status", "Assignee", "Story Point", "Priority", "Severity", "Project" );

	@PostMapping( "/excel" )
	public String downloadExcel( HttpServletResponse response, RedirectAttributes redirectAttributes, @ModelAttribute TaskReportRequestDto dto, HttpSession session ) throws IOException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		List<TaskDto> list = projectReportService.generateTaskReport( dto, token );
		if ( !list.isEmpty() ) {
			response.setContentType( "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" );
			response.setHeader( "Content-Disposition", "attachment; filename=report.xlsx" );
			ProjectResponseDto projectDto = projectService.findById( dto.getProjectId(), token );
			String sprintName = sprintService.findName( dto.getSprintId(), token );
			Workbook workbook = excelUtility.generateExcel( headers, list, projectDto.getName() + "-" + sprintName + " Report" );
			workbook.write( response.getOutputStream() );
			workbook.close();
			return null;
		} else {
			redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_NO_RECORDS_FOR_REPORT );
		}
		return REDIRECT_REPORT_PAGE;
	}

	@PostMapping( "/pdf" )
	public String downloadPdf( HttpServletRequest req, RedirectAttributes redirectAttributes, HttpServletResponse response, @ModelAttribute TaskReportRequestDto dto, HttpSession session ) throws IOException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		List<TaskDto> list = projectReportService.generateTaskReport( dto, token );
		if ( !list.isEmpty() ) {
			response.setContentType( "application/pdf" );
			response.setHeader( "Content-Disposition", "attachment; filename=report.pdf" );
			ProjectResponseDto projectDto = projectService.findById( dto.getProjectId(), token );
			if ( projectDto != null ) {
				byte[] pdfBytes = pdfUtility.generatePdfContent( headers, list, projectDto.getName(), "" );
				response.getOutputStream().write( pdfBytes );
			} else {
				byte[] pdfBytes = pdfUtility.generatePdfContent( headers, list, "", "" );
				response.getOutputStream().write( pdfBytes );
			}
			return null;

		} else {
			redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_NO_RECORDS_FOR_REPORT );
		}
		return REDIRECT_REPORT_PAGE;
	}

	@PostMapping( "/active/sprints/excel" )
	public String downloadActiveSprintExcel( HttpServletResponse response, Model model, @ModelAttribute SprintReportRequestDto dto, RedirectAttributes redirectAttributes, HttpSession session ) throws IOException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		SprintDto currentSprint = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), dto.getProjectId() );
		if ( currentSprint != null ) {
			dto.setSprintId( currentSprint.getId() );
			List<TaskDto> list = projectReportService.generateActiveSprintReport( dto, token );
			if ( !list.isEmpty() ) {

				ProjectResponseDto projectDto = projectService.findById( dto.getProjectId(), token );
				String sprintName = sprintService.findName( dto.getSprintId(), token );

				try ( Workbook workbook = excelUtility.generateExcel( headers, list, projectDto.getName() + "-" + sprintName + " Report" ) ) {
					response.setContentType( "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" );
					response.setHeader( "Content-Disposition", "attachment; filename=report.xlsx" );
					workbook.write( response.getOutputStream() );
					return null;
				} catch ( Exception e ) {
					log.error( e.getMessage(), e );
					redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_SOMETHING_WRONG );

				}

			} else {
				redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_NO_RECORDS_FOR_REPORT );
			}

		} else {
			redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_NO_ACTIVE_SPRINT );
		}
		return REDIRECT_ACTIVE_SPRINT_REPORT_PAGE;

	}

	@PostMapping( "/active/sprints/pdf" )
	public String downloadActiveSprintPdf( HttpServletRequest req, HttpServletResponse response, RedirectAttributes redirectAttributes, @ModelAttribute SprintReportRequestDto dto, HttpSession session ) throws IOException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		SprintDto currentSprint = sprintService.findCurrentSprint( token, loggedInUser.getCompanyId(), dto.getProjectId() );

		if ( currentSprint != null ) {
			dto.setSprintId( currentSprint.getId() );
			List<TaskDto> list = projectReportService.generateActiveSprintReport( dto, token );
			if ( !list.isEmpty() ) {
				response.setContentType( "application/pdf" );
				response.setHeader( "Content-Disposition", "attachment; filename=report.pdf" );

				ProjectResponseDto projectDto = projectService.findById( dto.getProjectId(), token );
				String sprintName = sprintService.findName( dto.getSprintId(), token );

				if ( projectDto != null ) {
					byte[] pdfBytes = pdfUtility.generatePdfContent( headers, list, projectDto.getName(), sprintName );
					response.getOutputStream().write( pdfBytes );
				} else {
					byte[] pdfBytes = pdfUtility.generatePdfContent( headers, list, "", "" );
					response.getOutputStream().write( pdfBytes );
				}
				return null;
			} else {
				redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_NO_RECORDS_FOR_REPORT );
			}
		} else {
			redirectAttributes.addFlashAttribute( Constants.ERROR_MSG, MSG_NO_ACTIVE_SPRINT );
		}
		return REDIRECT_ACTIVE_SPRINT_REPORT_PAGE;
	}

	@ResponseBody
	@PostMapping( "/send-email" )
	public String sendEmail( HttpServletResponse response, @ModelAttribute TaskReportRequestDto dto, HttpSession session ) throws IOException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );
		List<TaskDto> list = projectReportService.generateTaskReport( dto, token );
		if ( !list.isEmpty() ) {

			ProjectResponseDto projectDto = projectService.findById( dto.getProjectId(), token );
			String sprintName = sprintService.findName( dto.getSprintId(), token );
			try ( FileOutputStream fileOut = new FileOutputStream( loggedInUser.getId() + "report.xlsx" ) ) {
				Workbook workbook = excelUtility.generateExcel( headers, list, projectDto.getName() + "-" + sprintName + " Report" );
				workbook.write( fileOut );
				if ( dto.getProjectId() != null && dto.getProjectId() != 0 ) {
					ProjectResponseDto project = projectService.findById( dto.getProjectId(), token );
					emailService.send( "report.xlsx", project.getName() + " excel report", "We have attached excel report for " + project.getName(), loggedInUser.getUserName() );
				} else {
					emailService.send( "report.xlsx", " Excel report", "We have attached excel report", loggedInUser.getUserName() );
				}

				return "success";
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
				return MSG_SOMETHING_WRONG;
			} finally {
				new File( loggedInUser.getId() + "report.xlsx" ).delete();
			}

		} else {
			return MSG_NO_RECORDS_FOR_REPORT;
		}
	}

	@ResponseBody
	@PostMapping( "/active/sprints/send-mail" )
	public String sendMailForActiveSprintExcelReport( HttpServletResponse response, @ModelAttribute SprintReportRequestDto dto, HttpSession session ) throws IOException {
		String token = ( String ) session.getAttribute( Constants.TOKEN );
		LoginUserDto loggedInUser = ( LoginUserDto ) session.getAttribute( Constants.LOGGED_IN_USER );
		dto.setCompanyId( loggedInUser.getCompanyId() );

		List<TaskDto> list = projectReportService.generateActiveSprintReport( dto, token );
		if ( !list.isEmpty() ) {
			ProjectResponseDto projectDto = projectService.findById( dto.getProjectId(), token );
			String sprintName = sprintService.findName( dto.getSprintId(), token );

			try ( FileOutputStream fileOut = new FileOutputStream( loggedInUser.getId() + "report.xlsx" ) ) {
				Workbook workbook = excelUtility.generateExcel( headers, list, projectDto.getName() + "-" + sprintName + " Report" );
				workbook.write( fileOut );
				if ( dto.getProjectId() != null ) {
					ProjectResponseDto project = projectService.findById( dto.getProjectId(), token );
					emailService.send( "report.xlsx", project.getName() + " active sprint excel report", "We have attached excel report for active sprint of " + project.getName(), loggedInUser.getUserName() );
				} else {
					emailService.send( "report.xlsx", "Active sprint excel report", "We have attached active sprint excel report", loggedInUser.getUserName() );
				}
				return "success";
			} catch ( Exception e ) {
				log.error( e.getMessage(), e );
				return MSG_SOMETHING_WRONG;
			} finally {
				new File( loggedInUser.getId() + "report.xlsx" ).delete();
			}
		} else {
			return MSG_NO_RECORDS_FOR_REPORT;
		}

	}
}
