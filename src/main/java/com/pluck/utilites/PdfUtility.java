package com.pluck.utilites;

import java.io.ByteArrayOutputStream;
import java.util.List;

import org.springframework.stereotype.Service;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.pluck.dto.task.TaskDto;

@Service
public class PdfUtility {

	public byte[] generatePdfContent( List<String> pdfHeaders, List<TaskDto> tasks, String projectName, String sprintName ) {
		try ( ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ) {
			Document document = new Document();
			PdfWriter.getInstance( document, outputStream );

			document.open();

			Font boldFont = new Font( Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLUE );

			Font headerFont = new Font( Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.BLACK );

			Paragraph newTitle;

			// Create the title paragraph
			if ( sprintName == null || sprintName.isEmpty() ) {
				newTitle = new Paragraph( projectName + " Task report", boldFont );
			} else {
				newTitle = new Paragraph( projectName + " - " + sprintName + " Report", boldFont );
			}

			document.add( newTitle );
			document.add( new Paragraph( "\n" ) );
			document.add( new Paragraph( "\n" ) );
			PdfPTable table = new PdfPTable( pdfHeaders.size() );
			table.setWidthPercentage( 100 );

			for ( String header : pdfHeaders ) {
				PdfPCell headerCell1 = new PdfPCell( new Paragraph( header, headerFont ) );
				table.addCell( headerCell1 );
			}
			for ( TaskDto dto : tasks ) {
				PdfPCell dataCell1 = new PdfPCell( new Paragraph( dto.getTicket() ) );
				PdfPCell dataCell2 = new PdfPCell( new Paragraph( dto.getTitle() ) );
				PdfPCell dataCell3 = new PdfPCell( new Paragraph( dto.getStatus() ) );
				PdfPCell dataCell4 = new PdfPCell( new Paragraph( dto.getAssigneName() ) );
				PdfPCell dataCell5 = new PdfPCell( new Paragraph( dto.getStory_point() ) );
				PdfPCell dataCell6 = new PdfPCell( new Paragraph( dto.getPriority() ) );
				PdfPCell dataCell7 = new PdfPCell( new Paragraph( dto.getSeverity() ) );
				PdfPCell dataCell8 = new PdfPCell( new Paragraph( dto.getProjectName() ) );
				table.addCell( dataCell1 );
				table.addCell( dataCell2 );
				table.addCell( dataCell3 );
				table.addCell( dataCell4 );
				table.addCell( dataCell5 );
				table.addCell( dataCell6 );
				table.addCell( dataCell7 );
				table.addCell( dataCell8 );
			}

			document.add( table );

			document.close();

			return outputStream.toByteArray();
		} catch ( Exception e ) {
			e.printStackTrace();
			return new byte[ 0 ];
		}
	}
}
