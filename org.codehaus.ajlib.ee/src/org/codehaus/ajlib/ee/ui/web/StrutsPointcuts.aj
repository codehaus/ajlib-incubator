/*
 * Created on Sep 9, 2003
 *
 * Copyright (c) 2003 New Aspects of Security. All Rights Reserved.
 */
package org.codehaus.ajlib.ee.ui.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 * @author Ron Bodkin
 *
 */
public class StrutsPointcuts {
    public pointcut actionExecute(Action action, ActionMapping mapping, ActionForm form, 
        HttpServletRequest request, HttpServletResponse response) :
        execution(ActionForward Action.execute(ActionMapping, ActionForm, 
            HttpServletRequest, HttpServletResponse)) && this(action) && 
        args(mapping, form, request, response);
        
    public pointcut genericActionExecute(Action action, ActionMapping mapping, ActionForm form, 
        ServletRequest request, ServletResponse response) :
        execution(ActionForward Action.execute(ActionMapping, ActionForm, 
            ServletRequest, ServletResponse)) && this(action) && 
        args(mapping, form, request, response);
}
