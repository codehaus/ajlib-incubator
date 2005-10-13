package org.codehaus.ajlib.runtime;

/**
 * Structure based default implementation of
 * {@link AbstractShutdownHook}.
 * The hook is installed before the first execution of a
 * <code>main</code> method.
 * 
 * @author Eric Bodden
 * @see java.lang.Runtime#addShutdownHook(java.lang.Thread)
 */
public aspect ShutdownHook extends AbstractShutdownHook {
 
    /**
     * Pointcut specifying when the hook shall be installed. 
     */
    protected pointcut init():
        execution(public static void *.main(String[])) &&
        !cflowbelow(execution(public static void *.main(String[])));
    
}