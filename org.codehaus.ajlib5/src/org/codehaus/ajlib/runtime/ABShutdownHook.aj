package org.codehaus.ajlib.runtime;

/**
 * Annotation based default implementation of
 * {@link AbstractShutdownHook}.
 * The hook is installed before the first execution of a
 * method tagged with the <code>InstallShutdownHook</code> annotation.
 * 
 * @author Eric Bodden
 * @see java.lang.Runtime#addShutdownHook(java.lang.Thread)
 */
public aspect ABShutdownHook extends AbstractShutdownHook {
 
    /**
     * Marker annotation. Should be attached to a method on
     * whose execution the hook is to be installed.
     */
    public @interface InstallShutdownHook{}

    /**
     * Pointcut specifying when the hook shall be installed. 
     */
    protected pointcut init(): 
        execution(@InstallShutdownHook * *.*(..)) &&
        !cflowbelow(execution(@InstallShutdownHook * *.*(..)));
    
}