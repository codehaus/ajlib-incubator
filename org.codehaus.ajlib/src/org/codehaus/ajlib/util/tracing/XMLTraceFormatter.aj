/*
 * Created on Jun 18, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.codehaus.ajlib.util.tracing;

//import java.util.StringTokenizer;

import org.aspectj.lang.JoinPoint;

/**
 * @author Steven Park
 *
 */
public class XMLTraceFormatter extends BasicTraceFormatter {
	
	public String enter(JoinPoint joinPoint) {
		StringBuffer logStr = new StringBuffer("<" + joinPoint.getKind());
		if(joinPoint.getKind().indexOf("method") > -1) {
			
			logStr.append(" method=\"" + joinPoint.getSignature().getName() + "\"");
		}
		if(joinPoint.getThis() != null) {
			logStr.append(" this=\"" + joinPoint.getThis() + "\"");
		}
		logStr.append(">");
		if(joinPoint.getArgs() != null && joinPoint.getArgs().length>0) {
			logStr.append("\n<args>");
			appendArguments(logStr, joinPoint.getArgs());
			logStr.append("\n</args>");
		}
		return logStr.toString();
	}
	
	/*protected String getMethodName(JoinPoint joinPoint) {
		String shortString = joinPoint.toShortString();
		StringTokenizer st = new StringTokenizer(shortString, "\\.");
		String method = "";
		st.nextToken();   // Throw away first token because it has a open paren that will cause parsing not to work
		while(st.hasMoreTokens()) {
			String token = st.nextToken();
			int openParenIndex = token.indexOf("(");
			if(openParenIndex > -1) {
				method = token.substring(0, openParenIndex);
			}
		}
		return method;
	}*/
	
	protected void appendArguments(StringBuffer logStr, Object[] arguments) {
        for (int i = 0; i < arguments.length; i++) {
            logStr.append("\n<arg>\n"+traceString(arguments[i])+"\n</arg>");
        }
	}
	
	public String exit(JoinPoint joinPoint) {
		return "</" + joinPoint.getKind() + ">";
	}
	
	public String exitReturning(JoinPoint joinPoint, Object retVal) {
		return "<retval value=\"" + retVal + "\"/>\n" + exit(joinPoint);
	}
	
	public String exitThrowing(JoinPoint joinPoint, Throwable thrown) {
		return "<exception throwable=\"" + thrown + "\"/>\n" + exit(joinPoint);
	}
}
