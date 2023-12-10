package com.pluck.dto.company;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CompanyPageDto {

	public List<Content> content;
	public Pageable pageable;
	public boolean last;
	public int totalPages;
	public int totalElements;
	public int number;
	public int size;
	public Sort sort;
	public boolean first;
	public int numberOfElements;
	public boolean empty;
}
