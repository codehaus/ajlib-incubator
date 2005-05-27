/*
* Created on 7-Jul-2003
*
* Copyright (c) 2003 New Aspects of Security.
* All rights reserved.
*
* Ron Bodkin
*/
package org.codehaus.ajlib.ee.ui.servlet;

import javax.servlet.http.*;
import javax.servlet.jsp.*;

/** Defines pointcuts for common events for HTTP servlets. */ 
public class HttpServletPointcuts {
    /** requestExec matches execution of servlet service and the various do* methods 
     * on http servlet*/
    public pointcut requestExec(HttpServlet servlet, HttpServletRequest request, HttpServletResponse response) :
        (execution(* HttpServlet.do*(..)) || execution(* service(..))) &&
        this(servlet) && args(request, response);

    /** jspServiceExec matches jspService on an HttpJspPage. */        
    public pointcut jspServiceExec(HttpJspPage jspPage, HttpServletRequest request, HttpServletResponse response) : 
        execution(public void HttpJspPage._jspService(HttpServletRequest, HttpServletResponse)) &&
        this(jspPage) && args(request, response);
}
