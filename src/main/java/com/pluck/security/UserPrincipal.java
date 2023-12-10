package com.pluck.security;

import java.util.Collection;
import java.util.List;
import java.util.Objects;

import org.springframework.security.core.AuthenticatedPrincipal;
import org.springframework.security.core.GrantedAuthority;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class UserPrincipal implements AuthenticatedPrincipal {

	private Long id;

	private Long companyId;

	private String companyName;

	private Long projectId;

	private String projectName;

	private String username;

	private String name;

	@JsonIgnore
	private String password;

	private Collection<? extends GrantedAuthority> authorities;

	private List<String> authorityNames;

	@Override
	public boolean equals( Object o ) {
		if ( this == o ) {
			return true;
		}

		if ( o == null || getClass() != o.getClass() ) {
			return false;
		}

		UserPrincipal that = ( UserPrincipal ) o;
		return Objects.equals( id, that.id );
	}

	@Override
	public int hashCode() {
		return Objects.hash( id );
	}
}
