package org.codehaus.ajlib.util;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Arrays;

import static org.codehaus.ajlib.util.AutoEquals.ReferenceRecursion.IDENTITY;

/**
 * AutoEqualsAspect - Implements the <code>equals</code> method for objects based on field equality.
 * Simply annotate the class and the fields to be compared on with the <code>AutoEquals</code> annotation type.
 * For the following example, <code>true</code> would be returned.
 * 
 * <code><pre>
@AutoEquals
public class Main {
    
    //to be compared
    @AutoEquals int field; 

    //not to be compared
    int field2; 
    
    public static void main(String[] args) {
        
        Main a = new Main();
        a.field = 1;
        a.field2 = 2;
        Main b = new Main();
        b.field = 1;
        b.field2 = 3;
        System.out.println(a.equals(b));
        
    }
    
}
 </pre></code>
 *
 * @author Eric Bodden
 * @see http://www.angelikalanger.com/Articles/JavaSpektrum/01.Equals-Part1/01.Equals1.html
 */
public aspect AutoEqualsAspect {

    //marker interface
    private interface HasAutoEquals{}
    declare parents: (@AutoEquals *) implements HasAutoEquals;

    declare error: get(@AutoEquals transient * *.*): "Transient fields cannot be used for comparison."; 
    declare error: set(@AutoEquals transient * *.*): "Transient fields cannot be used for comparison."; 

    public boolean HasAutoEquals.equals(Object o) {

        //fast check for identity
        if(this==o) {
            return true;
        }
        
        //if no direct subclass of Object, call super()
        if(this.getClass().getSuperclass()!=Object.class) {
            if (!super.equals(o)) { 
                return false;
            }
        }
        
        //check for non-nullness        
        if (o == null) { 
            return false;
        }
        
        //check for equal classes
        //this is usually a requirement for the transitivity of equals(..),
        //we take it as a convention here
        Class clazz = this.getClass();
        if(clazz!=o.getClass()) {
            return false;
        }
        
        Field[] fields = clazz.getDeclaredFields();
        
        //over all fields
        for (Field field : fields) {
            //if annotated
            Annotation anno = field.getAnnotation(AutoEquals.class);
            if(anno!=null) {
                if(Modifier.isTransient(field.getModifiers())) {
                    //we do not compare transient fields
                    continue;
                }
                
                try {
                    //get both values
                    Object fieldValue = field.get(this);
                    Object otherFieldValue = field.get(o);
                    
                    AutoEquals ae = (AutoEquals) anno;
                    
                    if(ae.referenceComparison()==IDENTITY) {
                        //compare on identify only
                        if(fieldValue!=otherFieldValue) {
                            return false;
                        }
                    }

                    if (fieldValue == null) {
                        if (otherFieldValue != null) { 
                          return false; 
                        }
                    } 
                    else {
                        if(fieldValue.getClass().isArray()) {
                            //compare on arrays
                            if(otherFieldValue.getClass().isArray()) {
                                //compare two arrays
                                if(!Arrays.equals((Object[])fieldValue,(Object[])otherFieldValue)) {
                                    return false;
                                }
                            } else {
                                //one is an array, the other one not
                                return false;
                            }
                        } else {
                            //compare on ordinary reference types
                            if (!(fieldValue.equals((otherFieldValue)))) { 
                              return false;
                            }
                        }
                    }
                    
                } catch(IllegalAccessException e) {
                    throw new RuntimeException("Could not determine equality for two objects of type "+clazz.getName()+".",e);
                }

            }
        }

        //all fine up till here? then we are equal
        return true;
    }
    
    //Fix for StringBuffer access:
    //StringBuffer does not compare equals() correctly, so we fix it.
    boolean around (StringBuffer b1, StringBuffer b2): cflow(within(AutoEqualsAspect)) && call(public boolean Object.equals(Object)) && target(b1) && args(b2) {
        if(b1.getClass()==b2.getClass()) {
            return b1.toString().equals(b2.toString());
        } else {
            return false;
        }
    }

}
