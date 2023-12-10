package com.pluck.dto.task;

import java.util.List;

import com.pluck.dto.user.Pageable;
import com.pluck.dto.user.Sort;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TaskPagerDto {
	public List<Content> content;
	public Pageable pageable;
	public int totalElements;
	public int totalPages;
	public boolean last;
	public int size;
	public int number;
	public Sort sort;
	public int numberOfElements;
	public boolean first;
	public boolean empty;

}
