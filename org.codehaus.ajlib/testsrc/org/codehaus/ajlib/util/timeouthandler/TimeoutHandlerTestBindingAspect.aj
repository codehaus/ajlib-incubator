package org.codehaus.ajlib.util.timeouthandler;

aspect TimeoutHandlerTestBindingAspect extends TimeoutHandler {

    public pointcut longRunningTimeoutMessages():execution(private * TimeouthandlerTest.do*(..));
    
    public long getTimeOut(){
        return 500;
    }

}
