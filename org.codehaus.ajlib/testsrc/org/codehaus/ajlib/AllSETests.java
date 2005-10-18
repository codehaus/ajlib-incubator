package org.codehaus.ajlib;

import org.codehaus.ajlib.util.ressourcecontroller.RessourceControllerTestCase;
import org.codehaus.ajlib.util.version.VersionTester;
import org.codehaus.ajlib.util.timeouthandler.TimeouthandlerTest;
import org.codehaus.ajlib.util.tracing.ExecutionTracingTestCase;

import junit.framework.Test;
import junit.framework.TestSuite;


public class AllSETests {

	public static Test suite() {
		TestSuite suite = new TestSuite("Test for org.codehaus.ajlib");
		//$JUnit-BEGIN$

		//$JUnit-END$
        suite.addTestSuite(TimeouthandlerTest.class);
		suite.addTestSuite(VersionTester.class);
		suite.addTestSuite(RessourceControllerTestCase.class);
        suite.addTestSuite(ExecutionTracingTestCase.class);
		return suite;
	}

}
