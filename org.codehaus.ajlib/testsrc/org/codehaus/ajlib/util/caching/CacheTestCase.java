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

import junit.framework.TestCase;

public class CacheTestCase extends TestCase {
    public void testCacheUsedWithOneArgument(){
        CacheTestObject cto=new CacheTestObject(1);
        int initialValue=cto.getValue(1);
        cto.ensureReturningDifferentValues();
        int hopefullycachedValue=cto.getValue(1);
        assertTrue(initialValue==hopefullycachedValue);
    }

    public void testCacheUsedWithTwoArguments(){
        CacheTestObject cto=new CacheTestObject(1);
        int initialValue=cto.getValue(1,2);
        cto.ensureReturningDifferentValues();
        int hopefullycachedValue=cto.getValue(1,2);
        assertTrue(initialValue==hopefullycachedValue);
    }
    
    public void testCacheNotUsedWithTwoServerObjects(){
        CacheTestObject cto=new CacheTestObject(1);
        CacheTestObject cto2=new CacheTestObject(2);
        int initialValue=cto.getValue(1);
        int hopefullyNotCachedValue=cto2.getValue(1);
        assertFalse(initialValue==hopefullyNotCachedValue);
    }

    public void testInvalidatedCache(){
        CacheTestObject cto=new CacheTestObject(1);
        int initialValue=cto.getValue(1);
        cto.ensureReturningDifferentValues();
        int hopefullycachedValue=cto.getValue(1);
        assertTrue(initialValue==hopefullycachedValue);
        cto.doSomethingInvalidatingCache();
        int hopefullyNotCachedValue=cto.getValue(1);
        assertTrue(initialValue!=hopefullyNotCachedValue);
        cto.ensureReturningDifferentValues();
        int hopefullycachedValueAgain=cto.getValue(1);
        assertTrue(hopefullycachedValueAgain==hopefullyNotCachedValue);
    }

    
    
}
