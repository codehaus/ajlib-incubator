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
	declare precedence: GuardTracing, AbstractTracing+;

	void around(Tracer tracer, JoinPoint joinPoint) : 
      within(Tracer+) && execution(void Tracer.*(JoinPoint, ..)) && args(joinPoint, ..) && this(tracer) && if(!tracer.isTraceEnabled(joinPoint)) {
		// do nothing
	}
}
