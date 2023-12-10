package com.pluck.utilites;

import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;

import com.pluck.dto.task.TaskDto;

@Component
public class ExcelUtility {

	private void writeTitle( XSSFWorkbook workbook, XSSFSheet sheet, String title ) {

		Row row = sheet.createRow( 1 );

		CellStyle style = workbook.createCellStyle();
		XSSFFont font = workbook.createFont();
		font.setFontHeight( 18 );
		font.setColor( Font.COLOR_NORMAL );
		style.setFont( font );

		createCell( workbook, sheet, row, 1, title, style );
	}

	private void writeHeaderLine( XSSFWorkbook workbook, XSSFSheet sheet, List<String> headers ) {

		Row row = sheet.createRow( 3 );

		CellStyle style = workbook.createCellStyle();
		XSSFFont font = workbook.createFont();
		font.setBold( true );
		font.setFontHeight( 16 );
		style.setFont( font );

		for ( int i = 0; i < headers.size(); i++ ) {
			createCell( workbook, sheet, row, i, headers.get( i ), style );
		}

	}

	private void createCell( XSSFWorkbook workbook, XSSFSheet sheet, Row row, int columnCount, Object value, CellStyle style ) {
		sheet.autoSizeColumn( columnCount );
		Cell cell = row.createCell( columnCount );
		if ( value instanceof Integer ) {
			cell.setCellValue( ( Integer ) value );
		} else if ( value instanceof Boolean ) {
			cell.setCellValue( ( Boolean ) value );
		} else if ( value instanceof Long ) {
			cell.setCellValue( ( Long ) value );
		} else {
			cell.setCellValue( ( String ) value );
		}
		cell.setCellStyle( style );
	}

	private void writeDataLines( XSSFWorkbook workbook, XSSFSheet sheet, List<TaskDto> list ) {

		int rowNum = 4;
		CellStyle style = workbook.createCellStyle();
		XSSFFont font = workbook.createFont();
		font.setFontHeight( 14 );
		style.setFont( font );
		for ( int i = 0; i < list.size(); i++ ) {
			Row row = sheet.createRow( rowNum );
			TaskDto dto = list.get( i );
			createCell( workbook, sheet, row, 0, dto.getTicket(), style );
			createCell( workbook, sheet, row, 1, dto.getTitle(), style );
			createCell( workbook, sheet, row, 2, dto.getStatus(), style );
			createCell( workbook, sheet, row, 3, dto.getAssigneName(), style );
			createCell( workbook, sheet, row, 4, dto.getStory_point(), style );
			createCell( workbook, sheet, row, 5, dto.getPriority(), style );
			createCell( workbook, sheet, row, 6, dto.getSeverity(), style );
			createCell( workbook, sheet, row, 7, dto.getProjectName(), style );
			rowNum++;
		}

	}

	public Workbook generateExcel( List<String> headers, List<TaskDto> list, String title ) {
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet( "tasks" );
		writeTitle( workbook, sheet, title );
		writeHeaderLine( workbook, sheet, headers );
		writeDataLines( workbook, sheet, list );
		return workbook;

	}
}
