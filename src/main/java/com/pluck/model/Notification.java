package com.pluck.model;

import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

	private Long notificationId;

	private String messageSubject;

	private String messageBody;

	private Long messageFrom;

	private List<User> messageTo;

	private String status;

	private Timestamp addedDate;

	private Long companyId;

}
