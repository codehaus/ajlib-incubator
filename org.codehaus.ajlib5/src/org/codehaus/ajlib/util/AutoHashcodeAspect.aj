package org.codehaus.ajlib.util;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Arrays;

import static org.codehaus.ajlib.util.AutoEquals.ReferenceRecursion.IDENTITY;

/**
 * AutoHashcodeAspect - Implements the <code>hashCode</code> method for objects based on field contents.
 * Annotations are used as in the {@link AutoEqualsAspect} to steer how the hashcode is calculated:
 * The hashcode is calculated based on any field with the {@link AutoEquals} annotation, except those with
 * {@link AutoEquals#notHashcodeRelevant()} set to <code>true</code>.
 * 
 * Transient fields are ignored. For fields with {@link AutoEquals#referenceComparison()} set to
 * {@link AutoEquals#ReferenceRecursion.IDENTITY}, the identity hashcode is taken instead of recursing deeper. 
 *
 * @author Eric Bodden
 * @see java.util.System#identityHashCode(Object)
 * @see http://www.angelikalanger.com/Articles/JavaSpektrum/03.HashCode/03.HashCode.html
 */
public aspect AutoHashcodeAspect {
    
    public int AutoEqualsAspect.HasAutoEquals.hashCode() {
        
        Class clazz = this.getClass();
        Field[] fields = clazz.getDeclaredFields();

        int hashcode = 7919; //some prime number
        final int factor = 7159; //some other prime number
        
        //if no direct subclass of Object, call super()
        if(this.getClass().getSuperclass()!=Object.class) {
            //update full hash code
            hashcode = hashcode * factor + super.hashCode();
        }
        
        //over all fields
        for (Field field : fields) {
            //if annotated
            Annotation anno = field.getAnnotation(AutoEquals.class);
            if(anno!=null) {
                if(Modifier.isTransient(field.getModifiers())) {
                    //we do not compare transient fields
                    continue;
                }

                AutoEquals ae = (AutoEquals) anno;

                //if relevant for hashcode calculation
                if(ae.hashcodeRelevant()) {
                    
                    try {
                        //calculate hash code of field value
                        Object fieldValue = field.get(this);
                        
                        int value;

                        if(ae.referenceComparison()==IDENTITY) {
                            //compare use identity hash codes
                            value = System.identityHashCode(fieldValue);
                        } else {
                            //recurse
                            if(fieldValue==null) {
                                value = 0;
                            } else if(fieldValue.getClass().isArray()) {
                                value = Arrays.hashCode((Object[])fieldValue);
                            } else {
                                value = fieldValue.hashCode();
                            }
                        }
                        
                        //update full hash code
                        hashcode = hashcode * factor + value;
                    } catch(IllegalAccessException e) {
                        throw new RuntimeException("Could not determine hashcode for an object of type "+clazz.getName()+".",e);
                    }
                }
            }
        }
        
        return hashcode;
    }

    
    //Fix for StringBuffer access:
    //StringBuffer does not calculate hashCode() correctly, so we fix it.
    int around (StringBuffer b): cflow(within(AutoEqualsAspect)) && call(public int Object.hashCode()) && target(b) {
        return b.toString().hashCode();
    }
}
