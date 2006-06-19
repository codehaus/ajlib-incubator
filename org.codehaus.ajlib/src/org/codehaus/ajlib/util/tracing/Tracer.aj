package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.JoinPoint;

/**
 * Interface for any tracing service to implement.
 */
public interface Tracer {
	
	/**
	 * Trace on entry 
	 * @param joinPoint the join point entered 
	 */
	void enter(JoinPoint joinPoint);
	
	/**
	 * Trace exit after returning from a join point that returns nothing (void). 
	 * @param joinPoint the join point exited
	 */
	void exitVoid(JoinPoint joinPoint);
	
	/**
	 * Trace exit after returning from a join point that returns a value.
	 * @param retVal the value returned 
	 */
	void exitReturning(JoinPoint joinPoint, Object retVal);
	
	/**
	 * Trace exit after throwing from a join point.
	 * @param thrown the throwable thrown
	 */
	void exitThrowing(JoinPoint joinPoint, Throwable thrown);

	/**
	 * Is the tracer enabled at all? Used to guard executions of tracing methods, i.e.,
	 * to avoid calling when not enabled.  
	 */
	public boolean isTraceEnabled(JoinPoint joinPoint);
}
