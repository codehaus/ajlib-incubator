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

import org.aspectj.lang.JoinPoint;

/**
 * @author Arno
 *
 */
public interface CacheProvider {
    
    public Object getKey(JoinPoint jp); 

    public Object getCachedValue(Object key); 

    public void invalidateCache(); 
    
    public void cache(JoinPoint jp,Object result);

}
