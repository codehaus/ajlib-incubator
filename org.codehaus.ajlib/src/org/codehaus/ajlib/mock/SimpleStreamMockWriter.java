package org.codehaus.ajlib.mock;

import java.io.PrintStream;

import org.aspectj.lang.JoinPoint;

public class SimpleStreamMockWriter implements MockWriter {
    private PrintStream out=System.out;

    public PrintStream getOut() {
        return out;
    }

    public void setOut(PrintStream out) {
        this.out = out;
    }

    public void writeReturning(JoinPoint jp, Object obj) {
        out.print(jp.toString());
        out.print("\t");
        if (jp.getThis()!=null)
            out.print(jp.getThis());
        out.print("\t");
        if (jp.getTarget()!=null)
            out.print(jp.getTarget());
        out.print("\t");
        writeargs(out,jp.getArgs());
        out.print("\treturned:\t");
        out.println(obj);
    }

    private void writeargs(PrintStream out, Object[] args) {
        if (args==null)
            return;
        for (int i = 0; i < args.length; i++) {
            Object object = args[i];
            out.print(object);
            out.print("\t");
        }
        
    }

    public void writeThrowing(JoinPoint jp, Throwable t) {
        // TODO Auto-generated method stub
        
    }
    
}
