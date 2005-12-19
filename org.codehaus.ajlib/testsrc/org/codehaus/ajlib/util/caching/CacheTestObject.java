/*******************************************************************
 * Copyright (c) Arno Schmidmeier, http://www.AspectSoft.de
 * All rights reserved. 
 * This program and the accompanying materials are made available 
 * under the terms of the Common Public License v1.0 
 * which accompanies this distribution and is available at 
 * http://www.eclipse.org/legal/cpl-v10.html 
 *  
 * Contributors: 
 *     Arno Schmidmeier
 * ******************************************************************/

package org.codehaus.ajlib.util.caching;


/**
 * @author Arno Schmidmeier
 *
 */

public class CacheTestObject {

    private int increment;

    public CacheTestObject(int increment) {
        this.increment=increment;
    }

    public int getValue(int value) {
        return increment+value;
    }

    public void ensureReturningDifferentValues() {
        increment++;
    }

    public int getValue(int i, int j) {
        return (i+increment)*(j+increment);
    }

    public void doSomethingInvalidatingCache() {
    }

    
}
