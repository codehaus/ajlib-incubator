package org.codehaus.ajlib.util.tracing;

import org.aspectj.lang.JoinPoint;

public class BasicTraceFormatter implements TraceFormatter {

	public String enter(JoinPoint joinPoint) {
        StringBuffer logStr = new StringBuffer("trace enter: "+getTracePoint(joinPoint)+" ");
        if (joinPoint.getThis() != null) {
            logStr.append(", this: "+traceString(joinPoint.getThis()));
        }
		// verbosity?
	    if (joinPoint.getArgs() != null && joinPoint.getArgs().length>0) {
			logStr.append(", args: "+arguments(joinPoint.getArgs()));
	    }
		return logStr.toString();
	}
	
	protected String arguments(Object[] arguments) {
        StringBuffer logStr = new StringBuffer();
        for (int i = 0; i < arguments.length; i++) {
            logStr.append((i>0 ? ", ":"")+ "arg "+i+" = "+traceString(arguments[i]));
        }
        return logStr.toString();
	}

	protected String exit(JoinPoint joinPoint) {
		return "trace exit: "+getTracePoint(joinPoint);
	}
	
	public String exitReturning(JoinPoint joinPoint, Object retVal) {
        StringBuffer logStr = new StringBuffer(exit(joinPoint));
        logStr.append(", return = "+traceString(retVal));
		return logStr.toString();
	}

	public String exitThrowing(JoinPoint joinPoint, Throwable thrown) {
        StringBuffer logStr = new StringBuffer(exit(joinPoint));
        logStr.append(", throwing = "+traceString(thrown));
		return logStr.toString();
	}

	public String exitVoid(JoinPoint joinPoint) {
        return exit(joinPoint);
	}

	public String traceString(Object obj) {
        if (obj == null) {
            return "(null)";
        }
        if (obj instanceof CustomTraceable) {
            return ((CustomTraceable)obj).toTraceString();
        }
        return obj.toString();		
	}

	/** String representing the join point being traced. */
    public String getTracePoint(JoinPoint joinPoint) {
        return joinPoint.getSignature().toString();
    }
}
