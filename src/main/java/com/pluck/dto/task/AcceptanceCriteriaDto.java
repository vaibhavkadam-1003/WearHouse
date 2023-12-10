
package com.pluck.dto.task;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class AcceptanceCriteriaDto {
	private int id;
	private String name;
	private Long project;
	private Long company;
}
