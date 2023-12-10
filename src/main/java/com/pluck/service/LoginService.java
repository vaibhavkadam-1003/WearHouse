package com.pluck.service;

import java.util.List;

import com.pluck.dto.ForgotPasswordRequestDto;
import com.pluck.dto.LoginFormDto;
import com.pluck.dto.LoginUserDto;
import com.pluck.dto.user.ChangePasswordDto;
import com.pluck.dto.user.SignUpRequestDto;

public interface LoginService {
	public String login( LoginFormDto dto, String ipAddress );

	public LoginUserDto loadLoggedInUser( String token );

	public String signUp( SignUpRequestDto signUpDto );

	public String changePassword( ChangePasswordDto changePassDto, String attribute );

	public String forgotPassword( ForgotPasswordRequestDto requestDto );

	public String getHighestRole( List<String> role );

	public Integer getHigherRoleValue( String role );

	public LoginUserDto getLoggedInUser( String token, Long project );

	public String getDefaultProjectToken( String userName, Long project, String token );

	public boolean isHigherAuthority( String currentRole, String highestRole );
}
