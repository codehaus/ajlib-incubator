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
public abstract aspect CachingAspect {

    /////////////////////////////////////////////////////////////
    // The pointcuts to extend
    public pointcut CacheInvalidatingMethods();
    public abstract pointcut ExpensiveMethods();
    
    /////////////////////////////////////////////////////////////
    // The configuration Properties
    

    public CacheProvider getCacheProvider() {
        return cacheProvider;
    }

    public void setCacheProvider(CacheProvider cacheProvider) {
        this.cacheProvider = cacheProvider;
    }

    private CacheProvider cacheProvider;


    /////////////////////////////////////////////////////////////
    // The aspect logic

    //TODO make Thread Save
    before():CacheInvalidatingMethods(){
        cacheProvider.invalidateCache();
    }

    
    Object around():ExpensiveMethods(){
        try{
            Object key=cacheProvider.getKey(thisJoinPoint);
            if (key!=null){
                return cacheProvider.getCachedValue(key);
            }
        }catch(RuntimeException e){            
        }
        Object toReturn=proceed();
        try{
            cacheProvider.cache(thisJoinPoint,toReturn);
        }catch(RuntimeException e){
        }
        return toReturn;
    }
    
}
