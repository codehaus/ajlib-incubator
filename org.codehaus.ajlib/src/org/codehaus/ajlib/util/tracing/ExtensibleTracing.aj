package org.codehaus.ajlib.util.tracing;

/** 
 * We create a base class to define tracing exclusions so the Java 5 version of the library can add on
 * annotations as another exclusion.
 * 
 * @author Ron Bodkin
 *
 */  
public class ExtensibleTracing {
	public pointcut inTracingExclusion(): 
		within(NotTraced);
}
