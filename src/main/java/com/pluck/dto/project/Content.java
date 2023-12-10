package com.pluck.dto.project;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Content {

	@JsonDeserialize( using = LocalDateDeserializer.class )
	@JsonSerialize( using = LocalDateSerializer.class )
	private LocalDate updatedOn;
	
	@JsonDeserialize( using = LocalDateDeserializer.class )
	@JsonSerialize( using = LocalDateSerializer.class )
	private LocalDate addedOn;
	
	private Long id;
	private String name;
	private String description;
	private LocalDate startDate;
	private LocalDate lastDate;
	private String status;
	private String logo;
	private Long companyId;
	private Long addedBy;	
	private Long updatedBy;
	private List<Long> owners;
	private List<Long> users;
}
