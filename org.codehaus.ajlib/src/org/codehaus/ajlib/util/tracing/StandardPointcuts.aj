/*
 * Created on Sep 8, 2003
 *
 * Copyright (c) 2003 New Aspects of Security. All Rights Reserved.
 */
package org.codehaus.ajlib.util.tracing;

/**
 * Defines commonly used pointcuts. This is a natural to use with
 * Java 1.5's static import. To be merged/replaced by the ajlib version.
 * 
 * @author Ron Bodkin
 *
 */
public class StandardPointcuts {
    /**
     * always false: matches no join points 
     */
    public pointcut never();
    
    /**
     * always true: matches all join points 
     */
    public pointcut always() : within(*);

    /** 
     * definition of a public join point that constitutes entry to a package
     * i.e., it excludes field access 
     * limitation: we get initialization of all types, since we can't (yet) restrict to publics
     */ 
    public pointcut entryPoint() :  
        execution(public * *(..)) || execution(public new(..)) || initialization(public new(..)) || //adviceexecution() || 
        staticinitialization(/*public*/ *);

    /** 
     * definition of a public join point
     */ 
    public pointcut publicPoint() : 
        entryPoint() || get(public * *.*) || set(public * *.*);

    /**
     * any "execution" join point: method execution, constructor execution, or advice execution 
     */        
    public pointcut anyExec():
        execution(* *(..)) || execution(new(..)) || adviceexecution();

    /**
     * any "call" join point: method call or constructor call 
     */        
    public pointcut anyCall():
        call(* *(..)) || call(new(..));

    /**
     * method call join point for a method with a signature that throws a checked exception
     */
    public pointcut callThrowingChecked() : 
        (call(* *(..) throws (Throwable || Exception+ && !RuntimeException+)) ||
         call(new(..) throws (Throwable || Exception+ && !RuntimeException+)));

    /**
     * method execution join point for a method with a signature that throws a checked exception
     */
    public pointcut execThrowingChecked() : 
        (execution(* *(..) throws (Throwable || Exception+ && !RuntimeException+)) ||
        execution(new(..) throws (Throwable || Exception+ && !RuntimeException+)));
}
