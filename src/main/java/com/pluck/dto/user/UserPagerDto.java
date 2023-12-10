package com.pluck.dto.user;

import java.util.ArrayList;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserPagerDto {
	private ArrayList<Content> content;
	private Pageable pageable;
	private boolean last;
	private int totalPages;
	private int totalElements;
	private int size;
	private int number;
	private int numberOfElements;
	private Sort sort;
	private boolean first;
	private boolean empty;

}
