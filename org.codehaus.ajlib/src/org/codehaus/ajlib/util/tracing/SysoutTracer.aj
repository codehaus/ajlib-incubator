package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.JoinPoint;

public class SysoutTracer implements Tracer {
	protected TraceFormatter formatter = new BasicTraceFormatter();
	
	public void setFormatter(TraceFormatter formatter) {
		this.formatter = formatter;
	}
	
	public TraceFormatter getTraceFormatter() {
		return formatter;
	}

	public void enter(JoinPoint joinPoint) {
		System.out.println(formatter.enter(joinPoint));		
	}

	public void exitReturning(JoinPoint joinPoint, Object retVal) {
		System.out.println(formatter.exitReturning(joinPoint, retVal));		
	}

	public void exitVoid(JoinPoint joinPoint) {
		System.out.println(formatter.exitVoid(joinPoint));		
	}
	
	public void exitThrowing(JoinPoint joinPoint, Throwable thrown) {
		System.out.println(formatter.exitThrowing(joinPoint, thrown));		
	}
}
