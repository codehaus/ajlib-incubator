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
 * @author Arno
 *
 */
public aspect CacheTestAspect extends CachingAspect {
    public CacheTestAspect(){
        this.setCacheProvider(new DefaultCacheProvider());
        this.setKeyProvider(new DefaultKeyProvider());
    }

    public pointcut CacheInvalidatingMethods():execution( * CacheTestObject.doSomethingInvalidatingCache());
    
    public pointcut ExpensiveMethods():execution(public int CacheTestObject.getValue(..));
    
    

}
