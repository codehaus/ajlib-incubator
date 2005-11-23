package org.codehaus.ajlib.util;

import static java.lang.annotation.RetentionPolicy.RUNTIME;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.ElementType.FIELD;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * 
 * 
 * @author Eric Bodden
 */
@Retention(RUNTIME)
@Target({TYPE,FIELD})
public @interface AutoEquals {

}
