package org.codehaus.ajlib.util;

import static org.codehaus.ajlib.util.AutoEquals.ReferenceRecursion.IDENTITY;

import java.util.ArrayList;
import java.util.List;

import junit.framework.TestCase;

/**
 * Tests the AutoHashCodeAspect
 * 
 * @author Eric Bodden
 */
public class AutoHashCodeTest extends TestCase {
    
    @AutoEquals
    class Foo {
        @AutoEquals int field1 = 0;
        int field2 = 0;
        @AutoEquals Object o = null;
        @AutoEquals(referenceComparison=IDENTITY) Object s = null;
        @AutoEquals Object array = null;
        @AutoEquals StringBuffer sb = null;
        @AutoEquals boolean b = false;
        @AutoEquals(hashcodeRelevant=true) String irrelevantString = null;
    }
    
    protected Foo foo;
    
    protected int originalCode; 
    
    public void setUp() {        
        foo = new Foo();
        originalCode = foo.hashCode();
    }
    
    public void testInt(){
        foo.field1 = 1;
        assertTrue(originalCode != foo.hashCode());
    }
    
    public void testObjectNullNonNull(){
        foo.o = new Object();
        assertTrue(originalCode != foo.hashCode());
    }
        
    public void testDifferentObjects(){
        foo.o = new String("123");
        originalCode = foo.hashCode();
        foo.o = new String("234");
        assertTrue(originalCode != foo.hashCode());

        //take same object with different content
        List<String> o = new ArrayList<String>();
        foo.o = o;
        originalCode = foo.hashCode();
        o.add("someContentThatShouldChangeTheHashCode");
        assertTrue(originalCode != foo.hashCode());
    }
    
    public void testDiffrentObjectsIdentity(){
        foo.s = new String("123");
        originalCode = foo.hashCode();
        foo.s = new String("234");
        assertTrue(originalCode != foo.hashCode());
        
        //take same object with different content
        List<String> o = new ArrayList<String>();
        foo.s = o;
        originalCode = foo.hashCode();
        o.add("someContentThatShouldNotChangeTheHashCode");
        assertEquals(originalCode,foo.hashCode());
    }
    
    public void testArray(){
        foo.array = new String[] {"someString"};
        assertTrue(originalCode != foo.hashCode());
    }
    
    public void testStringBuffer(){
        foo.sb = new StringBuffer("Foo");
        assertTrue(originalCode != foo.hashCode());
    }

    public void testBoolean(){
        foo.b = true;
        assertTrue(originalCode != foo.hashCode());
    }
    
    public void testIrrelevantField(){
        foo.irrelevantString = "someIrrelevantData";
        assertEquals(originalCode,foo.hashCode());
    }
    
    public void testOverride() {
        final int CONSTANT = 8734632;
        
        Foo f = new Foo() {

            public int hashCode() {
                return CONSTANT;
            }
            
        };
        
        //aspect should not affect existing implementations
        assertEquals(f.hashCode(),CONSTANT);
    }

}
