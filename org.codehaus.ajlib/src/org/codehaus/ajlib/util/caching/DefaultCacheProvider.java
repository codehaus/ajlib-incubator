/*******************************************************************
 * Copyright (c) 2005-2006 Arno Schmidmeier, http://www.AspectSoft.de
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

import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.JoinPoint;

/**
 * @author Arno
 *
 */
public class DefaultCacheProvider implements CacheProvider {
    private Map map=new HashMap();

    public void cache(JoinPoint jp, Object result) {
        map.put(new DefaultHashKey(jp),result);
    }

    public Object getCachedValue(Object key) {
        return map.get(key); 
    }

    public Object getKey(JoinPoint jp) {
        DefaultHashKey newKey=new DefaultHashKey(jp);
        if (map.containsKey(newKey))
            return newKey;
        return null;
    }

    public void invalidateCache() {
        Map oldMap=map;
        map=new HashMap();
        oldMap.clear();
        oldMap=null;
    }

    public boolean contains(Object key) {
        return map.containsKey(key);
    }
    
    
}
