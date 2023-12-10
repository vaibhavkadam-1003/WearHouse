package com.pluck.dto.smtp;

import com.pluck.dto.company.CompanyDto;

import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
public class SmtpDto {
	
		private Long id;
		private boolean authenticationEnabled;
		private CompanyDto company;
		private boolean enabled;
		private String mailId;
		private String password;
		private String smtpHost;
		private short smtpPort;
		private boolean tlsEnabled;
	}

