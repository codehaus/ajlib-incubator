package org.codehaus.ajlib.mock;

import org.aspectj.lang.JoinPoint;

public interface MockWriter {
    public void writeReturning(JoinPoint jp,Object obj);
    public void writeThrowing(JoinPoint jp,Throwable t);
}
