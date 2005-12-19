/*******************************************************************
 * Copyright (c) Arno Schmidmeier, http://www.AspectSoft.de
 * All rights reserved. 
 * This program and the accompanying materials are made available 
 * under the terms of the Common Public License v1.0 
 * which accompanies this distribution and is available at 
 * http://www.eclipse.org/legal/cpl-v10.html 
 *  
 * Contributors: 
 *     Arno Schmidmeier
 * ******************************************************************/


package org.codehaus.ajlib.util.timeouthandler;

import junit.framework.TestCase;

public class TimeouthandlerTest extends TestCase {

    public void testTimeOut(){
        try {
            doTimeOut();
            fail();
        } catch (TimeOutException e) {
        }
    }
    
    public void testNoTimeOut(){
        Object obj=doNoTimeOut();
        if (obj==null)
            fail("No Return Object received");
    }
    
    public void testExceptionThrown(){
        try{
            dothrowNullPointerException();
            fail("No NullPointerException received");
        }catch(NullPointerException e){
        }
        try {
            Thread.sleep(1000);
         } catch (InterruptedException e) {
         }
    }

    private void doTimeOut(){
       try {
           Thread.sleep(1000);
        } catch (InterruptedException e) {
            fail();
        }
    }

    private void dothrowNullPointerException() {
        throw new NullPointerException();
    }

    private Object doNoTimeOut() {
        return this;
    }
}
