package org.codehaus.ajlib.util.tracing;

import junit.framework.TestCase;
import org.codehaus.ajlib.util.tracing.ExecutionTracingTestCase.MockTracer;

public class Log4jExecutionTracingTestCase extends TestCase {

	public static aspect TestLog4jTracing extends Log4jExecutionTracing {
		declare parents: org.codehaus.ajlib.util.tracing.Log4jExecutionTracingTestCase.*TestTracedClass implements Traced;
	
		protected Tracer makeTracer(String typeName) {
			return new MockTracer(typeName);
		}
	}
	
	protected static class NestedTestTracedClass {		
	}
	
	protected static class TestTracedClass {
		public void voidMethod() {
			new NestedTestTracedClass();
		}
	}
	
	public void testTracedIsTraced() {
		new TestTracedClass();
		assertEquals(ExecutionTracingTestCase.lastMockTracer.name, TestTracedClass.class.getName());
	}

	public void testNestedTrace() {
		new TestTracedClass().voidMethod();
		assertEquals(ExecutionTracingTestCase.lastMockTracer.name, NestedTestTracedClass.class.getName());
	}
}
