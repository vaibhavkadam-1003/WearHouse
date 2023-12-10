package com.pluck.serializer;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CustomDateDeserializer extends JsonDeserializer<LocalDate> {

	@Override
	public LocalDate deserialize( JsonParser jsonparser, DeserializationContext ctxt ) throws IOException, JsonProcessingException {
		ObjectMapper mapper = new ObjectMapper();
		final JsonNode node = jsonparser.readValueAsTree();
		System.out.println( jsonparser.getText() );
		final String languageCode = node.textValue();
		System.out.println( node.toString() );

		String date = jsonparser.getValueAsString();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern( "d/MM/yyyy" );
		return LocalDate.parse( date, formatter );
	}

}
