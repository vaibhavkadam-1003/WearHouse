package com.pluck.dto.inviteUser;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class InvitePagerDto {

	public List<Content> content;
	public Pageable pageable;
	public int totalElements;
	public boolean last;
	public int totalPages;
	public int size;
	public int number;
	public Sort sort;
	public int numberOfElements;
	public boolean first;
	public boolean empty;

}
