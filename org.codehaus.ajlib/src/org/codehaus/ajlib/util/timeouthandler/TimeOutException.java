package org.codehaus.ajlib.util.timeouthandler;

public class TimeOutException extends RuntimeException {

    public TimeOutException(String timeOutMessage) {
        super(timeOutMessage);
    }
}
