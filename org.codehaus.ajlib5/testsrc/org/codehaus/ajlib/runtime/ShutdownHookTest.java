package org.codehaus.ajlib.runtime;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import junit.framework.TestCase;

/**
 * Test case for the ShutdownHook aspect.
 * Since we want to test if the hook is woven correctly for shutdown time,
 * we have to set up another virtual machine.
 * 
 * @author Eric Bodden
 */
public class ShutdownHookTest extends TestCase {

    final static String TOKEN = "123test123";
    
    /**
     * Tests the structure based shutdown hook aspect.
     */
    public void testShutdownHook() throws IOException {
        ProcessBuilder pb = prepareProcessBuilder(TestApp.class);
        Process p = pb.start();                
        String line = readLineFromProcess(p);
        
        if(!line.equals(TOKEN)) {
            //if this fails, the shutdown hook was
            //probably not properly installed
            fail();
            System.err.println(line);
        }                
    }

    /**
     * Tests the annotation based shutdown hook aspect.
     */
    public void testABShutdownHook() throws IOException {
        ProcessBuilder pb = prepareProcessBuilder(ABTestApp.class);
        Process p = pb.start();                
        String line = readLineFromProcess(p);
        
        if(!line.equals(TOKEN)) {
            //if this fails, the shutdown hook was
            //probably not properly installed
            fail();
            System.err.println(line);
        }                
    }

    /**
     * Returns the first line output by the process (or <code>null</code> is there is none).
     */
    private String readLineFromProcess(Process p) throws IOException {
        InputStream inputStream = p.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        String line = reader.readLine();
        return line;
    }

    /**
     * Prepares the process builder by adjusting the classpath.
     * @throws UnsupportedEncodingException 
     */
    private ProcessBuilder prepareProcessBuilder(Class testApp) throws UnsupportedEncodingException {
        ProcessBuilder pb = new ProcessBuilder("java",testApp.getCanonicalName());
        
        //adjust the classpath
        pb.redirectErrorStream(true);
        String processCP = pb.environment().get("CLASSPATH");
        String currentCP = System.getProperty("java.class.path");
        processCP += File.pathSeparatorChar + currentCP;
        pb.environment().put("CLASSPATH", processCP);
        return pb;
    }  
    
}

/**
 * Stub to be run by the JVM for the structure based shutdown hook.
 * The main method should be advised for initialization,
 * the advice should execute on shutdown.
 */
class TestApp {
    
    static aspect hookInterceptor {            
        before() : ShutdownHook.onShutdown() {
            System.out.println(ShutdownHookTest.TOKEN);
        }                        
    }
            
    public static void main(String[] args) {
    }        
}

/**
 * Stub to be run by the JVM for the annotation based shutdown hook.
 * The annotated method should be advised for initialization,
 * the advice should execute on shutdown.
 */
class ABTestApp {
    
    static {
        init();
        System.exit(0);
    }
    
    @ABShutdownHook.InstallShutdownHook static void init() {}
    
    static aspect hookInterceptor {            
        before() : ShutdownHook.onShutdown() {
            System.out.println(ShutdownHookTest.TOKEN);
        }                        
    }
            
}
