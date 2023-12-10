package com.pluck.service;

import java.util.List;

import com.pluck.dto.notification.NotificationResponceDto;

public interface NotificationService {

	List<NotificationResponceDto> getNotification( Long companyId, Long userId, String token );

	long delete( Long id, String token );

	long deleteAll( Long id, String token );

	NotificationResponceDto getNotificationById( Long id, String token );
}
