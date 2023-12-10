package com.pluck.dto.task;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserStoriesResponseHolder {
	List<UserStoryResponseDto> list;
}
