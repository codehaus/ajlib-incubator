package org.codehaus.ajlib.util;

import org.codehaus.ajlib.util.AutoEquals;
import static org.codehaus.ajlib.util.AutoEquals.ReferenceRecursion.IDENTITY;

import junit.framework.TestCase;

/**
 * Tests the AutoEqualsAspect
 * 
 * @author Eric Bodden
 */
public class AutoEqualsTest extends TestCase {
    
    @AutoEquals
    class Foo {
        @AutoEquals int field1; 
        int field2;
        @AutoEquals Object o = null;
        @AutoEquals(referenceComparison=IDENTITY) Object s = null;
        @AutoEquals Object array = null;
        @AutoEquals StringBuffer sb = null;
    }
    
    protected Foo foo1,foo2;
    
    public void setUp() {        
        foo1 = new Foo();
        foo2 = new Foo();        
    }
    
    public void testPositive() {
        
        foo1.field1 = 1;
        foo1.field2 = 2;
        foo2.field1 = 1;
        foo2.field2 = 3;
        
        assertTrue(foo1.equals(foo2));
    }
    
    public void testNegative() {
        
        foo1.field1 = 1;
        foo1.field2 = 1;
        foo2.field1 = 2;
        foo2.field2 = 1;
        
        assertFalse(foo1.equals(foo2));
    }

    public void testReferencePositive() {
        
        Object a = new Object();
        
        foo1.field1 = 1;
        foo1.field2 = 2;
        foo1.o = a;
        foo1.array = new String[]{"1","2"};
        foo2.field1 = 1;
        foo2.field2 = 3;
        foo2.o = a;
        foo2.array = new String[]{"1","2"};
        
        assertTrue(foo1.equals(foo2));
    }
    
    public void testReferenceNegative1stNull() {
        
        Object a = new Object();
        
        foo1.field1 = 1;
        foo1.field2 = 2;
        foo2.field1 = 1;
        foo2.field2 = 3;
        foo2.o = a;
        
        assertFalse(foo1.equals(foo2));
    }
    
    public void testReferenceNegative2ndNull() {
        
        Object a = new Object();
        
        foo1.field1 = 1;
        foo1.field2 = 2;
        foo1.o = a;
        foo2.field1 = 1;
        foo2.field2 = 3;
        
        assertFalse(foo1.equals(foo2));
    }
    
    public void testReferenceNegativeDifferent() {
        
        Object a = new Object();
        Object b = new Object();
        
        foo1.field1 = 1;
        foo1.field2 = 2;
        foo1.o = a;
        foo2.field1 = 1;
        foo2.field2 = 3;
        foo2.o = b;
        
        assertFalse(foo1.equals(foo2));
    }
    
    public void testReferenceNegativeShallow() {
        
        String a = new String ("a");
        String b = new String ("a");
        
        foo1.field1 = 1;
        foo1.field2 = 2;
        foo1.s = a;
        foo2.field1 = 1;
        foo2.field2 = 3;
        foo2.s = b;
        
        assertFalse(foo1.equals(foo2));
    }
    
    public void testStringBuffer() {
        foo1.sb = new StringBuffer("s");
        foo2.sb = new StringBuffer("s");

        assertTrue(foo1.equals(foo2));
    }
    
}
