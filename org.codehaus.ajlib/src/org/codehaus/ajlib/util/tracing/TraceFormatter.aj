package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.JoinPoint;

public interface TraceFormatter {
	String enter(JoinPoint joinPoint);
	String exitVoid(JoinPoint joinPoint);
	String exitReturning(JoinPoint joinPoint, Object retVal);
	String exitThrowing(JoinPoint joinPoint, Throwable thrown);
}
