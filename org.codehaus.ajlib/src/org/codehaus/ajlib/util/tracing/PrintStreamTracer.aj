package org.codehaus.ajlib.util.tracing;

import java.io.PrintStream;

import org.aspectj.lang.JoinPoint;

public class PrintStreamTracer implements Tracer {
	protected static final String defaultFormatterClass = System.getProperty("org.codehaus.ajlib.util.tracing.formatter", "org.codehaus.ajlib.util.tracing.BasicTraceFormatter"); 
	
	protected TraceFormatter formatter = makeFormatter();
	protected PrintStream printStream;
	
	private static TraceFormatter makeFormatter() {
		try {
			return (TraceFormatter)Class.forName(defaultFormatterClass).newInstance();
		} catch (Exception e) {
			System.err.println("Can't initialize formatter: "+defaultFormatterClass);
			e.printStackTrace();
			return new BasicTraceFormatter();
		}
	}
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
		getPrintStream().println(formatter.enter(joinPoint));		
	}

	public void exitReturning(JoinPoint joinPoint, Object retVal) {
		getPrintStream().println(formatter.exitReturning(joinPoint, retVal));		
	}

	public void exitVoid(JoinPoint joinPoint) {
		getPrintStream().println(formatter.exitVoid(joinPoint));		
	}
	
	public void exitThrowing(JoinPoint joinPoint, Throwable thrown) {
		getPrintStream().println(formatter.exitThrowing(joinPoint, thrown));		
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
