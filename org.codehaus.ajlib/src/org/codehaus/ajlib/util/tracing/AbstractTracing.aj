/**
 * 
 */
package org.codehaus.ajlib.util.tracing;

// We don't call this AbstractTracer, so it's clear that it's the protocol for tracing, not
// the implementation of a tracer service. 

/**
 * Base aspect for tracing the entry and exit of various join points.
 */
public abstract aspect AbstractTracing extends ExtensibleTracing {
    /** 
     * A tracer is used to provide the tracing service. Defaults to the system.out tracer.  
     */
	protected Tracer tracer = new PrintStreamTracer();

	/**
	 * Is this tracing aspect enabled at runtime?
	 */
	protected static boolean enabled = !Boolean.getBoolean(AbstractTracing.class.getPackage().getName()+".disabled");
	
	/**
	 * Sets the tracer used for tracing. Typically used to provide dependency inversion to
	 * configure a tracing aspect. Consider configuring the tracer with a specific formatter.
	 */
	public void setTracer(Tracer tracer) {
		this.tracer = tracer;
	}
	
	/**
	 * @returns the tracer.
	 */
	public Tracer getTracer() {
		return tracer;
	}

	/**
	 * Enable or disable tracing globally for all tracers.
	 */
	public static void setEnabled(boolean enabled) {
		AbstractTracing.enabled = enabled;
	}
	
	/**
	 * @returns whether or not tracing is enabled globally
	 */
	public static boolean isEnabled() {
		return AbstractTracing.enabled;
	}

    /** 
     * Defines the scope of where tracing should occur. Does not need to address recursive tracing:
     * this is always excluded. 
     */
	public pointcut traceScope() :
        kindedScope() && scope();
	
	/**
	 * Defines scope of tracing by kind of join points: defaults to not restricting by kind.
	 * Useful to limit tracing to, e.g., execution or call.
	 */
	public pointcut kindedScope() : StandardPointcuts.always();

	/**
	 * Defines the scope of application within the kind of tracing that's being done
	 */
	public abstract pointcut scope();

	// don't use this: apparently concrete aspects can't munge cflow either
//	/**
//	 * Defines join points caused by tracing.
//	 */
	public pointcut inTracing(): 
		cflow(within(Tracer+) && StandardPointcuts.anyExec());
//	public pointcut inTracing() : within(Tracer+ || AbstractTracing+);
//
//	static aspect SkipNestedTracing {
//		private pointcut tracing(): 
//			within(org.codehaus..*) && execution(void Tracer.*(..)); 
//		
//		void around() : tracing() && cflowbelow(tracing()) {			
//		}
//		void around() : tracing() && !cflowbelow(tracing()) {			
//			proceed();
//		}
//	}
    /** 
     * Defines a scope of where tracing occurs: avoids recursive tracing and 
     * restricts to the configured scope by any aspects that extend it. 
     */
    protected pointcut inScope() : if(enabled) && !inTracing() && traceScope() && !inTracingExclusion();
}
