/**
 * 
 */
package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.JoinPoint;

/**
 * Policy aspect to always guard tracing so if the associated logger isn't configured for debug,
 * there's no tracing.
 */
aspect GuardTracing {
	void around(Tracer tracer, JoinPoint joinPoint) : 
      execution(void Tracer.*(JoinPoint, ..)) && args(joinPoint) && this(tracer) && if(!tracer.isTraceEnabled(joinPoint)) {
		// do nothing
	}
}
