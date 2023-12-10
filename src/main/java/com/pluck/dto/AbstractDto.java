package com.pluck.dto;

import java.io.Serializable;
import java.time.LocalDate;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class AbstractDto<E> implements Serializable {

	private static final long serialVersionUID = 1L;

	//@JsonDeserialize( using = CustomDateDeserializer.class )
	@JsonDeserialize( using = LocalDateDeserializer.class )
	@JsonSerialize( using = LocalDateSerializer.class )
	private LocalDate addedOn;

	//@JsonDeserialize( using = CustomDateDeserializer.class )
	@JsonDeserialize( using = LocalDateDeserializer.class )
	@JsonSerialize( using = LocalDateSerializer.class )
	private LocalDate updatedOn;

	private String addedByUser;

	private String updatedByUser;


}
