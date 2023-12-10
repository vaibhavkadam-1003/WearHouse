package com.pluck.model;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@JsonIdentityInfo( generator = ObjectIdGenerators.PropertyGenerator.class, property = "id" )
@JsonIgnoreProperties( { "hibernateLazyInitializer", "handler" } )
public class Project {
	private Long id;
	private String name;
	private String description;
	private LocalDate startDate;
	private LocalDate lastDate;
	private String status;
	private String logo;
	private Long companyId;
	private Long addedBy;
	private LocalDate addedOn;
	private Long updatedBy;
	private LocalDate updatedOn;
	private List<Long> owners;
	private List<Long> users;

}
