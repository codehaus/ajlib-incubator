package org.codehaus.ajlib.util.tracing;

import java.rmi.RemoteException;

import org.aspectj.lang.JoinPoint;

import junit.framework.TestCase;

public class XMLTraceFormatterTestCase extends TestCase {
	protected MockTracer tracer;
	protected TestTracedClass tracedObj;

	protected void setUp() throws Exception {
		tracer = new MockTracer();
		TestExecutionTracing.aspectOf().setTracer(tracer);
		
		// tricky: we want to test this value before any test case that might override it runs
		// we don't want to rely on any order of tests by JUnit
		assertTrue(AbstractTracing.isEnabled());
		
//		MonitorTracingAspect.returnCount = 0;
//		MonitorTracingAspect.throwCount = 0;	

		// turn off tracing to avoid tracing the constructor call
		AbstractTracing.setEnabled(false);
		tracedObj = createTestObj();
		AbstractTracing.setEnabled(true);
	}
	
	public void testEnterFormat() {
		tracedObj.mrHorrible(new Integer(1), 1);

		assertEquals(1, tracer.enterCount);
		assertEquals("<method-execution method=\"mrHorrible\" this=\"" + tracer.enterJp.getThis() + "\">\n<args>\n<arg>\n1\n</arg>\n<arg>\n1\n</arg>\n</args>", tracer.enterXML);
	}
	
	public void testExitFormatReturning() {
		tracedObj.mrHorrible(null, 0);
		
		assertEquals("<retval value=\"" + tracer.exitObj +"\"/>\n</method-execution>", tracer.exitReturningXML);
	}
	
	public void testExitFormattingThrowing() {
		try {
			tracedObj.throwingMethod();
		} catch (RemoteException e) {
			assertEquals("<exception throwable=\"" + tracer.exitObj.getClass().getName() + ": " + ((Throwable)tracer.exitObj).getMessage() + "\"/>\n</method-execution>", tracer.exitThrowingXML);
		}
	}
	
	public void testExitFormattingVoid() {
		tracedObj.voidMethod();
		
		assertEquals("</method-execution>", tracer.exitVoidXML);
	}
	
	public void testMethodWithoutArgs() {
		tracedObj.voidMethod();
		assertEquals("<method-execution method=\"voidMethod\" this=\"" + tracer.enterJp.getThis() + "\">\n</method-execution>", tracer.enterXML + "\n" + tracer.exitVoidXML);
	}
	
	public void testMethodWithArgs() {
		tracedObj.mrHorrible(new Integer(1), 1);
		assertEquals("<method-execution method=\"mrHorrible\" this=\"" + tracer.enterJp.getThis() + "\">\n<args>\n<arg>\n1\n</arg>\n<arg>\n1\n</arg>\n</args>\n<retval value=\"" + tracer.exitObj +"\"/>\n</method-execution>", tracer.enterXML + "\n" + tracer.exitReturningXML);
	}
	
	protected TestTracedClass createTestObj() {
		return new TestTracedClass();
	}

	private static aspect TestExecutionTracing extends ExecutionTracing {
		public pointcut scope() : within(XMLTraceFormatterTestCase.TestTraced*);
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
	
	protected class MockTracer implements Tracer {
		protected TraceFormatter formatter = new XMLTraceFormatter();
		int enterCount = 0;
		String enterXML = null;
		JoinPoint enterJp = null;
		String exitVoidXML = null;
		String exitReturningXML = null;
		String exitThrowingXML = null;
		Object exitObj = null;

		public void enter(JoinPoint joinPoint) {
			enterJp = joinPoint;
			enterXML = formatter.enter(joinPoint);
			enterCount++;
		}

		public void exitReturning(JoinPoint joinPoint, Object retVal) {
			exitReturningXML = formatter.exitReturning(joinPoint, retVal);
			exitObj = retVal;
		}

		public void exitThrowing(JoinPoint joinPoint, Throwable thrown) {
			exitThrowingXML = formatter.exitThrowing(joinPoint, thrown);
			exitObj = thrown;
		}

		public void exitVoid(JoinPoint joinPoint) {
			exitVoidXML = formatter.exitVoid(joinPoint);
		}
		
		public boolean isTraceEnabled(JoinPoint joinPoint) {
			return true;
		}
		
	}
}
