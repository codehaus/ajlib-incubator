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
            e.printStackTrace();
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
