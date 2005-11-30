/*
 * Created on 30.11.2005
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package org.codehaus.ajlib;

import org.codehaus.ajlib.runtime.ShutdownHookTest;
import org.codehaus.ajlib.util.AutoEqualsTest;
import org.codehaus.ajlib.util.AutoHashCodeTest;

import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * AllTests
 * 
 * @author Eric Bodden
 */
public class AllTests {

    public static Test suite() {
        TestSuite suite = new TestSuite("Test for org.codehaus.ajlib");
        //$JUnit-BEGIN$
        suite.addTestSuite(ShutdownHookTest.class);
        suite.addTestSuite(AutoEqualsTest.class);
        suite.addTestSuite(AutoHashCodeTest.class);
        //$JUnit-END$
        return suite;
    }

}
