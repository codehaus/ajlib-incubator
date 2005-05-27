package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.JoinPoint;

public interface Tracer {
	void enter(JoinPoint joinPoint);
	void exitVoid(JoinPoint joinPoint);
	void exitReturning(JoinPoint joinPoint, Object retVal);
	void exitThrowing(JoinPoint joinPoint, Throwable thrown);
}
