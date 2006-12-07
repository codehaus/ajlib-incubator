package org.codehaus.ajlib.mock;

public abstract aspect AbstractMockDataAspect {
    
    public abstract pointcut Method2Mock();
    
    private MockWriter defaultMockWriter;
    
    protected MockWriter getMockWriter(){
        if (defaultMockWriter==null)
            defaultMockWriter=new SimpleStreamMockWriter();
        return defaultMockWriter;
    }
        
    after() returning (Object obj):Method2Mock(){
        getMockWriter().writeReturning(thisJoinPoint,obj);
    }

    after() throwing (Throwable t):Method2Mock(){
        getMockWriter().writeThrowing(thisJoinPoint,t);
    }

}
