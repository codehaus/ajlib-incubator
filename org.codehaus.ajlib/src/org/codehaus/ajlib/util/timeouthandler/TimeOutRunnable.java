package org.codehaus.ajlib.util.timeouthandler;

public abstract class TimeOutRunnable implements Runnable {
    protected TimeOutRunnable(ResultsReceiver toWakeUp){
        this.toWakeUp=toWakeUp;
    }
    
    private ResultsReceiver toWakeUp;
        
    public abstract Object proceeding();
    
    public void start(){
        new Thread(this).start();
    }
    
    public void run(){
        Object toReturn=null;
        try {
            toReturn = proceeding();
        } catch (RuntimeException e) {
            toWakeUp.setRuntimeException(e);
        }
        toWakeUp.setResult(toReturn);
    }
}
