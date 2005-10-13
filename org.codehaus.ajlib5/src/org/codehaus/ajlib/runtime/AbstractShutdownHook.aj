package org.codehaus.ajlib.runtime;

/**
 * This aspect provides the pointcut <code>onShutdown()</code>, 
 * which matches shutdown time.
 * Code executed before/after onShutdown is executed in a shutdown
 * hook as specified in {@link java.lang.Runtime#addAbstractShutdownHook(java.lang.Thread)}.
 * Consequently, this code is executed in a separate thread,
 * using <code>around</code> cannot bypass the shutdown.
 * <p>
 * This is an abstract aspect. Subaspects should provide an impliementation of the
 * <code>init()</code> pointcut.
 * <p>
 * Usage:<br>
 * <code>
   before(): AbstractShutdownHook.onShutdown() {
      System.out.println("System is going down...");
   }
   </code>
 * 
 * @author Eric Bodden
 * @see java.lang.Runtime#addAbstractShutdownHook(java.lang.Thread)
 */
public abstract aspect AbstractShutdownHook {
   
    /* ***** Shutdown Handling ****** */
    
    /** The shutdown hook. This must be installed some time during runtime. */
    private final static Thread hook = new Thread() {
        public void run() {
            AbstractShutdownHook.notifyShutdown();
        }
    };
    
    /**
     * The exposed pointcut.
     */
    public pointcut onShutdown(): execution(private void AbstractShutdownHook.notifyShutdown());

    /**
     * Empty method, necessary to be notified about shutdown by the actual hook.
     */
    private static void notifyShutdown() {}

    /* ***** Initialization ****** */
    
    /**
     * Pointcut specifying when the hook shall be installed. 
     */
    protected abstract pointcut init();       
    
    /** Is the shutdown hook already installed? */
    private boolean initialized = false;
    
    /**
     * Installs the hook.
     */
    private void init() {
        Runtime.getRuntime().addShutdownHook(
                hook
        );
    }
        
    /**
     * Triggers the initializer installing the shutdown hook. 
     */
    before() : init() {
        if(!initialized) {
            init();
            initialized = true;
        }
    }
    
}