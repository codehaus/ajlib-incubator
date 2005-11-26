package org.codehaus.ajlib.util;

import static java.lang.annotation.RetentionPolicy.RUNTIME;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.ElementType.FIELD;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * Marker annotation for Fields and Classes.
 * Use <code>SHALLOW</code> to compare object references by reference equality
 * rather than recursing.
 * @see AutoEqualsAspect
 * @author Eric Bodden
 */
@Retention(RUNTIME)
@Target({TYPE,FIELD})
public @interface AutoEquals {

    enum ReferenceRecursion {
        EQUALITY,
        IDENTITY
        }
    
    ReferenceRecursion referenceComparison() default ReferenceRecursion.EQUALITY;
    
}
