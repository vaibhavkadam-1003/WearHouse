package com.pluck.service;

import java.util.List;

import com.pluck.dto.smtp.SmtpDto;

public interface SmtpService {
	
	List<SmtpDto> findAllSmtp(String token);

	SmtpDto findSmtp(long id, String attribute);

	String save(SmtpDto smtpDto , String token);
}
