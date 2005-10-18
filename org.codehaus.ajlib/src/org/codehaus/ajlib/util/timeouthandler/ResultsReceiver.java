package org.codehaus.ajlib.util.timeouthandler;

public interface ResultsReceiver {
    public void setResult(Object result);
    
    public void setRuntimeException(RuntimeException exception);
}
