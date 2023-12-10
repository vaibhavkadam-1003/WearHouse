package com.pluck.dto.project;

import java.util.ArrayList;

import com.pluck.dto.user.Pageable;
import com.pluck.dto.user.Sort;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProjectPagerDto {

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
