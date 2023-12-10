package com.pluck.dto.inviteUser;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Pageable {

	public Sort sort;
	public int offset;
	public int pageNumber;
	public int pageSize;
	public boolean paged;
	public boolean unpaged;

}