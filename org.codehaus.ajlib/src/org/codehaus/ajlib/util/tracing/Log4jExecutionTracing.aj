/**
 * @author Ron Bodkin with code drawn from Matthew Webster's example posted to aj-users 1/28/2005
 */
package org.codehaus.ajlib.util.tracing;


public abstract aspect Log4jExecutionTracing extends ExecutionTracing pertypewithin(*){
    before(): staticinitialization(*) && inScope() {
        String name = thisJoinPointStaticPart.getSignature().getDeclaringTypeName();
        tracer = new Log4jTracer(name);
	}
}
