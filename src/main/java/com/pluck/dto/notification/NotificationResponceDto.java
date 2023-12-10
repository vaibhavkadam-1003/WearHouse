package com.pluck.dto.notification;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NotificationResponceDto {

	private Long notificationId;

	private String messageSubject;

	private String messageBody;

	private Long messageFrom;

	private String status;

	private Timestamp addedDate;

	private Long companyId;
}
