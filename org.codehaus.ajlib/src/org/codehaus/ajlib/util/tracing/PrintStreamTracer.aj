package org.codehaus.ajlib.util.tracing;

import java.io.PrintStream;

import org.aspectj.lang.JoinPoint;

public class PrintStreamTracer implements Tracer {
	protected TraceFormatter formatter = new BasicTraceFormatter();
	protected PrintStream printStream;
	
	public PrintStreamTracer() {
		this(System.out);
	}
	
	public PrintStreamTracer(PrintStream printStream) {
		this.printStream = printStream; 
	}
	
	public void setFormatter(TraceFormatter formatter) {
		this.formatter = formatter;
	}
	
	public TraceFormatter getTraceFormatter() {
		return formatter;
	}

	public void enter(JoinPoint joinPoint) {
		printStream.println(formatter.enter(joinPoint));		
	}

	public void exitReturning(JoinPoint joinPoint, Object retVal) {
		printStream.println(formatter.exitReturning(joinPoint, retVal));		
	}

	public void exitVoid(JoinPoint joinPoint) {
		printStream.println(formatter.exitVoid(joinPoint));		
	}
	
	public void exitThrowing(JoinPoint joinPoint, Throwable thrown) {
		printStream.println(formatter.exitThrowing(joinPoint, thrown));		
	}
	
	public boolean isTraceEnabled(JoinPoint joinPoint) {
		return true;
	}
	
	public void setPrintStream(PrintStream printStream) {
		this.printStream = printStream;
	}
	
	public PrintStream getPrintStream() {
		return printStream;
	}
}
