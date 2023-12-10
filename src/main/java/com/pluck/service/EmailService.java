package com.pluck.service;

public interface EmailService {
	public void send( String filename, String subject, String body, String to );
}
