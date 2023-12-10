package com.pluck.service;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;

import com.pluck.dto.inviteUser.Content;
import com.pluck.model.InvitatedUser;

public interface InviteUserService {

	Map<String, List<String>> invite( InvitatedUser invitatedUser, String token );

	public List<Content> findAll( String token ) throws URISyntaxException;

}