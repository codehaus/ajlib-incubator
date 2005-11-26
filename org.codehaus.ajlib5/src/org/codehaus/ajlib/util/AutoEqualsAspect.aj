package org.codehaus.ajlib.util;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
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
 * @author Eric Bodden
 */
public aspect AutoEqualsAspect {

    //marker interface
    private interface HasAutoEquals{}
    declare parents: (@AutoEquals *) implements HasAutoEquals;
    
    public boolean HasAutoEquals.equals(Object o) {

        Class clazz = this.getClass();
        if(!clazz.equals(o.getClass())) {
            return false;
        }
        
        Field[] fields = clazz.getDeclaredFields();
        
        //over all fields
        for (Field field : fields) {
            //if annotated
            Annotation anno = field.getAnnotation(AutoEquals.class);
            if(anno!=null) {
                try {
                    //get both values
                    Object fieldValue = field.get(this);
                    Object otherFieldValue = field.get(o);
                    
                    //if they are reference-equals, they are equal
                    if(fieldValue==otherFieldValue) {
                        continue;
                    }
    
                    //if one of them is null (and the other one is not), they are unequal
                    if(fieldValue==null) {
                        return false;
                    }
                    
                    AutoEquals ae = (AutoEquals) anno;
                    if(ae.referenceComparison()==IDENTITY) {
                        return false;
                    }
                    
                    //check equality recursively
                    if(!fieldValue.equals(otherFieldValue)) {
                        return false;
                    }
                } catch(IllegalAccessException e) {
                    throw new RuntimeException("Could not determine equality for two objects of type "+clazz.getName()+".",e);
                }

            }
        }

        //all fine up till here? then we are equal
        return true;
    }

}
