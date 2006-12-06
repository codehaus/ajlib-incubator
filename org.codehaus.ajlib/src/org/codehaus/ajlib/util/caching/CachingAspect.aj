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
    private CacheProvider cacheProvider;
    private KeyProvider keyProvider;
    

    public CacheProvider getCacheProvider() {
        return cacheProvider;
    }

    public void setCacheProvider(CacheProvider cacheProvider) {
        this.cacheProvider = cacheProvider;
    }
    
    public KeyProvider getKeyProvider() {
        return keyProvider;
    }

    public void setKeyProvider(KeyProvider keyProvider) {
        this.keyProvider = keyProvider;
    }

    /////////////////////////////////////////////////////////////
    // The aspect logic

    private void audit(RuntimeException e){
        e.printStackTrace();
    }
    
    
    //TODO make Thread Save
    before():CacheInvalidatingMethods(){
        cacheProvider.invalidateCache();
    }

    
    Object around():ExpensiveMethods(){
        try{
            Object key=keyProvider.getKey(thisJoinPoint);
            if (key!=null){
                if (cacheProvider.contains(key))
                        return cacheProvider.getCachedValue(key);
            }
        }catch(RuntimeException e){
            audit(e);
        }
        Object toReturn=proceed();
        try{
            cacheProvider.cache(thisJoinPoint,toReturn);
        }catch(RuntimeException e){
            audit(e);
        }
        return toReturn;
    }
    
}
