/**
 * 
 */
package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.reflect.AdviceSignature;

/**
 * The core of execution tracing, which is most often used when tracing code you control (e.g.,
 * you wrote). One extends this aspect with a concrete aspect that defines
 * <p><code>tracePoint()</code></p>
 * @see LoggerExecutionTracing for tracing to a logger
 */
public abstract aspect ExecutionTracing extends AbstractTracing {
	
    /**
     * defines scope of tracing: limits to method-execution, constructor-execution and
     * adviceexecution join points.
     * 
     * @see StandardPointcuts.anyExec()  
     */        
    public pointcut kindedScope() : StandardPointcuts.anyExec();
	
    /**
     * execution of any method that returns a value in scope  
     */        
    public pointcut scopedRetVal(): 
        execution(!void *(..)) && inScope();

    /**
     * execution of any method that returns void in scope  
     */        
    public pointcut scopedRetVoid(): 
        (execution(void *(..)) || execution(new(..))) && inScope();

    /**
     * executions of advice in scope
     */        
    // advice execution is handled specially to trace returns values from
    // around advice 
    public pointcut scopedAdviceExec(): 
		adviceexecution() && inScope();
        
    /** trace entry to any matching execution join point */
    before() : inScope() {
		// XXX Is it useful to trace <code>this</code> before constructor execution? 
        tracer.enter(thisJoinPoint);
    }
    
    /** trace method exit, returning a value including constructor */
    after() returning (Object value): scopedRetVal() {
		tracer.exitReturning(thisJoinPoint, value);
    }    

    /** trace normal method exit, returning void */
    after() returning: scopedRetVoid() {
		tracer.exitVoid(thisJoinPoint);
    }    
    
    /** trace all advice-execution returns */
    after() returning (Object value): scopedAdviceExec() {
        if (value == null) {
            // reflective code to test for void return vs. returning null
            AdviceSignature sig = (AdviceSignature)thisJoinPointStaticPart.getSignature();
            if (sig.getReturnType()==Void.TYPE) {
                tracer.exitVoid(thisJoinPoint);
            } else {
                tracer.exitReturning(thisJoinPoint, null);
            }
        } else {
            tracer.exitReturning(thisJoinPoint, value);
        }
    }    

    /** trace any exit by exception */
    after() throwing (Throwable throwable): inScope() {
		tracer.exitThrowing(thisJoinPoint, throwable);
    }
		
}
