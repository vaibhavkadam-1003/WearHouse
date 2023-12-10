package com.pluck.dto.user;

import java.io.Serializable;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InvalidTokenDto implements Serializable {

	private static final long serialVersionUID = 5889846828880911162L;

	private long id;

	private Long userId;

	private String token;

	private LocalDateTime expiryDate;

}
