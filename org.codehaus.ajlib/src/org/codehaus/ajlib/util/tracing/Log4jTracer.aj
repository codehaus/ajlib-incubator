package org.codehaus.ajlib.util.tracing;

import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;

// This adds a dependency on log4j... but it will only be loaded if extended & used by
public class Log4jTracer implements Tracer {
	private Logger logger;
	private TraceFormatter formatter = new BasicTraceFormatter();
	
	public Log4jTracer() {		
	}
	
	public Log4jTracer(String loggerName) {
		logger = Logger.getLogger(loggerName);
	}
	
	public void setLogger(Logger logger) {
		this.logger = logger;
	}
	
	public void setFormatter(TraceFormatter formatter) {
		this.formatter = formatter;
	}

	public TraceFormatter getTraceFormatter() {
		return formatter;
	}

	// TODO: report bug: don't report on no lazyTjp if no tjp used!!!
	public void enter(JoinPoint joinPoint) {
		logger.debug(formatter.enter(joinPoint));
	}

	public void exitVoid(JoinPoint joinPoint) {
		logger.debug(formatter.exitVoid(joinPoint));
	}

	public void exitReturning(JoinPoint joinPoint, Object retVal) {
		logger.debug(formatter.exitReturning(joinPoint, retVal));
	}

	public void exitThrowing(JoinPoint joinPoint, Throwable thrown) {
		logger.debug(formatter.exitThrowing(joinPoint, thrown));
	}

	/**
	 * Policy aspect to always guard tracing so if the associated logger isn't configured for debug,
	 * there's no tracing.
	 */
	static aspect GuardTracing {
		void around(Log4jTracer tracer) : 
	      execution(void Tracer.*(..)) && this(tracer) && if(!tracer.logger.isDebugEnabled()) {
			// do nothing
		}
	}
}
