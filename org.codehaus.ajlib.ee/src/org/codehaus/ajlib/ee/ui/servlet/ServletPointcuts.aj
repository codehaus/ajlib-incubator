/*
* Created on 7-Jul-2003
*
* Copyright (c) 2003 New Aspects of Security.
* All rights reserved.
*
* Ron Bodkin
*/
package org.codehaus.ajlib.ee.ui.servlet;

import javax.servlet.*;
import javax.servlet.jsp.*;

/** Defines pointcuts for common servlet and JSP events. */ 
public class ServletPointcuts {
    public pointcut requestExec(Servlet servlet, ServletRequest request, ServletResponse response) : 
        execution(* service(..)) && this(servlet) && args(request, response);
        
    public pointcut filterExec(Filter filter, ServletRequest request, ServletResponse response, FilterChain chain) : 
        execution(public void Filter.doFilter(ServletRequest, ServletResponse, FilterChain)) &&
        this(filter) && args(request, response, chain);
        
    public pointcut jspServiceExec(ServletRequest request, ServletResponse response) : 
        execution(public void JspPage+._jspService(..)) &&
        args(request, response);
        
    public pointcut jspWriteCall(JspWriter jspWriter) : 
        call(public * JspWriter.*(..)) && target(jspWriter);
}
