package org.codehaus.ajlib.util.tracing;

import java.rmi.RemoteException;

import org.aspectj.lang.JoinPoint;

import junit.framework.TestCase;

public class ExecutionTracingTestCase extends TestCase {
	protected MockTracer tracer;
	protected TestTracedClass tracedClass;
	
	public void setUp() {
		tracer = new MockTracer();
		TestExecutionTracing.aspectOf().setTracer(tracer);
		
		// tricky: we want to test this value before any test case that might override it runs
		// we don't want to rely on any order of tests by JUnit
		assertTrue(AbstractTracing.isEnabled());
		
//		MonitorTracingAspect.returnCount = 0;
//		MonitorTracingAspect.throwCount = 0;	

		AbstractTracing.setEnabled(false);
		tracedClass = new TestTracedClass();
		TestTracedMonitorAspect.aspectOf();
		AbstractTracing.setEnabled(true);
	}

	public void tearDown() {
		AbstractTracing.setEnabled(true);
	}

	public void testMatchConstructor() {
		tracedClass = new TestTracedClass();

		assertEquals(1, tracer.enterCount);
		assertNotNull(tracer.exitVoidJp);
		assertNull(tracer.exitReturningJp);
		assertNull(tracer.exitThrowingJp);
		assertEquals(JoinPoint.CONSTRUCTOR_EXECUTION, tracer.enterJp.getKind());
		assertEquals(2, MonitorTracingAspect.aspectOf().adviceExecutedCount);
	}

	public void testMatchMethodRetVoid() {	
		tracedClass.voidMethod();
		assertEquals(1, tracer.enterCount);
		assertNotNull(tracer.exitVoidJp);
		assertNull(tracer.exitThrowingJp);
		assertEquals(JoinPoint.METHOD_EXECUTION, tracer.enterJp.getKind());
	}
	
	public void testDisabledTracing() {
		AbstractTracing.setEnabled(false);
		tracedClass = new TestTracedClass();
		tracedClass.voidMethod();
		assertEquals(0, tracer.enterCount);
		
		// cheapo performance test: verify no advice executes when not enabled
		// however, we can't test for construction of the JoinPoint...
		assertEquals(0, MonitorTracingAspect.aspectOf().adviceExecutedCount);
	}
		
	public void testCalls() {
		tracedClass = new TestTracedClass();
		assertEquals(TestTracedClass.NESTED_VAL, tracedClass.nestedMethod());
		assertEquals(new Integer(TestTracedClass.NESTED_VAL), tracer.exitObj);
		assertEquals(3, tracer.enterCount);
	}
	
	public void testNoMatchPcd() {
		new TestNotTracedClass().voidMethod();
		assertEquals(0, tracer.enterCount);
		assertEquals(0, MonitorTracingAspect.aspectOf().adviceExecutedCount);
	}
	
	public void testNoMatchExcludedSubclass() {
		AbstractTracing.setEnabled(false);
		TestNotTracedSubclass test = new TestNotTracedSubclass();
		AbstractTracing.setEnabled(true);
		test.voidMethod();
		
		assertEquals(0, tracer.enterCount);
	}

	public void testMatchExcludedSubclass() {
		TestNotTracedSubclass test = new TestNotTracedSubclass();
		test.nestedMethod();
		
		assertEquals(2, tracer.enterCount);
	}
	
	public void testStaticMeth() {
		TestTracedClass.staticMethod();
		assertEquals(1, tracer.enterCount);
		assertEquals(null, tracer.enterJp.getThis());
	}
	
	public void testThrowing() {
		try {
			tracedClass.throwingMethod();
			fail("tracing shouldn't prevent exceptions from percolating");
		} catch (RemoteException e) {
			assertEquals(1, tracer.enterCount);
			assertNotNull(tracer.exitThrowingJp);
			assertNull(tracer.exitReturningJp);
			assertNull(tracer.exitVoidJp);
			assertEquals(e, tracer.exitObj);
		}
	}
	
	public void testBeforeAdviceExec() {
		new TestNotTracedClass().beforeHook();
		
		assertEquals(1, tracer.enterCount);
		assertNotNull(tracer.exitVoidJp);
		assertNull(tracer.exitReturningJp);
		assertNull(tracer.exitThrowingJp);
		assertEquals(JoinPoint.ADVICE_EXECUTION, tracer.enterJp.getKind());
	}
	
	public void testAroundAdviceExec() {
		int ret = new TestNotTracedClass().aroundHook();
		
		assertEquals(1, tracer.enterCount);
		assertNull(tracer.exitVoidJp);
		assertNotNull(tracer.exitReturningJp);
		assertNull(tracer.exitThrowingJp);
		assertEquals(new Integer(ret), tracer.exitObj);
		assertEquals(JoinPoint.ADVICE_EXECUTION, tracer.enterJp.getKind());
	}

	public void testAfterThrowsAdviceExec() {
		// advice that throws...
		try {
			new TestNotTracedClass().afterHook();
			fail("test case is broken");
		} catch (RuntimeException e) {		
			assertEquals(1, tracer.enterCount);
			assertNull(tracer.exitVoidJp);
			assertNull(tracer.exitReturningJp);
			assertNotNull(tracer.exitThrowingJp);
			assertEquals(e, tracer.exitObj);
			assertEquals(JoinPoint.ADVICE_EXECUTION, tracer.enterJp.getKind());
		}
	}
	
	
	// robustness test
	//TODO: try various things that might generate aspect errors
	//e.g., null arguments
	
	public void robustnessTest() {
		// no NPE's please
		tracedClass.mrHorrible(new Integer(1), 1);
		tracedClass.mrHorrible(null, 0);
	}
	
	//TODO: real performance test
	// we leave testing initialization form org.codehaus.ajlib.util.tracing.noTracing variable to
	// integration test

	private static aspect TestExecutionTracing extends ExecutionTracing {
		public pointcut scope() : within(ExecutionTracingTestCase.TestTraced*);
	}

	protected static class TestNotTracedClass {
		public void voidMethod() {}

		public String beforeHook() {
			return "hi";
		}
		
		public int aroundHook() {
			return 5;
		}

		public void afterHook() {
		}
	}
	
	// ensure that we trace based on the within pointcut, not the parent class: 
	protected static class TestNotTracedSubclass extends TestTracedClass {
		public void voidMethod() {}		
	}
	
	protected static class TestTracedClass {
		boolean completedVoid = false;
		public static final int NESTED_VAL = 55;
		
		public void voidMethod() {
			completedVoid = true;
		}
		
		public Object throwingMethod() throws RemoteException {
			throw new RemoteException("test");
		}
		
		public int nestedMethod() {
			voidMethod();
			return NESTED_VAL;
		}
		
		public Object mrHorrible(Object o, int n) {
			if (false) {
				Object y = o.toString();
			}
			return null;
		}

		public static void staticMethod() {
		}
	}
	
	private class TracedClassExceptForAnnotation {
		public void voidMethod() {
		}
	}
	
	private static aspect TestNotTracedMonitorAspect {
		before() : execution(* TestNotTracedClass.beforeHook*(..)) {
			//no-op
		}
	}
	
	private static aspect TestTracedMonitorAspect {
		before() : call(* TestNotTracedClass.beforeHook*(..)) {
			//no-op
		}
		
		Object around() : call(* TestNotTracedClass.aroundHook*(..)) {
			//no-op
			return proceed();
		}
		
		after() returning: call(* TestNotTracedClass.afterHook*(..)) {
			throw new RuntimeException("test");
		}
	}
	
	/**
	 * better: use jMock  ...
	 * conceptually easier to unit test with a mock, but in practice it helps to have trace output
	 */
	protected class MockTracer implements Tracer {
		int enterCount = 0;
		JoinPoint enterJp = null;
		JoinPoint exitVoidJp = null;
		JoinPoint exitReturningJp = null;
		JoinPoint exitThrowingJp = null;
		Object exitObj = null;

		public void enter(JoinPoint joinPoint) {
			enterJp = joinPoint;
			enterCount++;
			System.out.println("enter "+joinPoint);
		}

		public void exitReturning(JoinPoint joinPoint, Object retVal) {
			exitReturningJp = joinPoint;
			exitObj = retVal;
		}

		public void exitThrowing(JoinPoint joinPoint, Throwable thrown) {
			exitThrowingJp = joinPoint;
			exitObj = thrown;
		}

		public void exitVoid(JoinPoint joinPoint) {
			exitVoidJp = joinPoint;
		}
	}
	
	static private aspect MonitorTracingAspect percflow(execution(* ExecutionTracingTestCase.test*(..))){
		int adviceExecutedCount = 0;
		
//        before() : staticinitialization(!com.myco..*) {}
        
		after() returning: adviceexecution() && this(TestExecutionTracing) {
			adviceExecutedCount++;
		}
		
		after() returning: call(JoinPoint.new(..)) {
			System.out.println("made jp");
		}
	}
}
