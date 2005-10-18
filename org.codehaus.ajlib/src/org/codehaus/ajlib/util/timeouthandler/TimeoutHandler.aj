package org.codehaus.ajlib.util.timeouthandler;

import org.aspectj.lang.JoinPoint;


public abstract aspect TimeoutHandler implements ResultsReceiver percflow(longRunningTimeoutMessages()){

    public abstract pointcut longRunningTimeoutMessages();
    public abstract long getTimeOut();
    
    private boolean done=false;
    private RuntimeException runtimeexception;
    private Object toReturn=null;
    
    Object around():longRunningTimeoutMessages(){
        TimeOutRunnable runnable=new TimeOutRunnable(this){
            public Object proceeding(){
                return proceed();
            }
        };
        long timeOutTime=getTimeOut();
        synchronized(this){
            runnable.start();
            try{
                wait(timeOutTime);
            }catch(InterruptedException ex){
                throw new TimeOutException(thisJoinPoint.toString());
            }
            if (done){
                if (runtimeexception==null)
                    return toReturn;
                else {
                    runtimeexception.fillInStackTrace();
                    throw runtimeexception;
                }
            }   else 
                throw new TimeOutException(thisJoinPoint.toString());
        }
    }
    
    protected String createTimeOutException(JoinPoint jp){
        return "Time out at "+jp.toString();
    }
    
    public synchronized void setResult(Object result){
        if (done)
            return;
        done=true;
        toReturn=result;
        this.notifyAll();
    }
    
    public synchronized void setRuntimeException(RuntimeException runtimeexception) {
        if (done)
            return;
        done=true;
        this.runtimeexception = runtimeexception;
        this.notifyAll();
    }
}
