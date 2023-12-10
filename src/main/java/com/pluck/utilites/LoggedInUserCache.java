package com.pluck.utilites;

import java.util.HashMap;
import java.util.Map;

public class LoggedInUserCache {
	private static Map<String, String> cache = new HashMap<String, String>();

	public static void setToken( String username, String token ) {
		cache.put( username, token );
	}

	public static boolean checkToken( String username ) {
		return cache.containsKey( username );
	}

	public static String getToken( String username ) {
		return cache.get( username );
	}
}
