package com.pluck.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class EmailServiceImpl implements EmailService {
	private static Map<String, Session> cache = null;
	static {
		if ( cache == null ) {
			cache = new HashMap<String, Session>();
		}
	}

	@Autowired
	private Environment env;

	@Override
	public void send( String filename, String subject, String body, String to ) {

		Properties props = new Properties();
		props.put( "mail.smtp.auth", "true" );
		props.put( "mail.smtp.starttls.enable", "true" );
		props.put( "mail.smtp.host", "smtp.gmail.com" );
		props.put( "mail.smtp.port", "587" );

		if ( !cache.containsKey( env.getProperty( "mail.sender" ) ) ) {
			Session session = Session.getInstance( props, new Authenticator() {
				@Override
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication( env.getProperty( "mail.sender" ), env.getProperty( "mail.pwd" ) );
				}
			} );
			cache.put( env.getProperty( "mail.sender" ), session );
		}

		try {
			Message message = new MimeMessage( cache.get( env.getProperty( "mail.sender" ) ) );
			message.setFrom( new InternetAddress( env.getProperty( "mail.sender" ) ) );
			message.setRecipients( Message.RecipientType.TO, InternetAddress.parse( to ) );
			message.setSubject( subject );

			MimeBodyPart messageBodyPart = new MimeBodyPart();
			messageBodyPart.setText( body );

			Multipart multipart = new MimeMultipart();
			multipart.addBodyPart( messageBodyPart );

			MimeBodyPart attachmentPart = new MimeBodyPart();
			DataSource source = new FileDataSource( filename );
			attachmentPart.setDataHandler( new DataHandler( source ) );
			attachmentPart.setFileName( filename );
			multipart.addBodyPart( attachmentPart );

			message.setContent( multipart );

			Transport.send( message );
			log.info( "email sent successfully" );

		} catch ( MessagingException e ) {
			e.printStackTrace();
		}
	}
}
