/*
 * Created on Aug 26, 2003
 *
 */
package org.codehaus.ajlib.util.tracing;

/**
 * @author Ron Bodkin
 *
 * Type for objects that have special tracing behavior. Implement this interface for a type to
 * create a specialized string representation when tracing, instead of the default, 
 * <code>toString</code>. Often applied with an inter-type declaration.
 * 
 */
public interface CustomTraceable {
	/** Return a custom string format to be used for tracing. */
    String toTraceString();
}
