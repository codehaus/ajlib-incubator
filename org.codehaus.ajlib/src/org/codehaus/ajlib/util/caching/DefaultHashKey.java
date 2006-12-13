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
public class DefaultHashKey {
    JoinPoint jp;
    
    public DefaultHashKey(JoinPoint jp) {
        this.jp=jp;
    }

    public boolean equals(Object arg) {
        if (arg==null)
            return false;
        if (!(arg instanceof DefaultHashKey))
            return false;
        if (arg==this)
            return true;
        DefaultHashKey key=(DefaultHashKey )arg;
        if (jp==null)
            return false;
        if (key.jp==null)
            return false;
//        if (!jp.getStaticPart().equals(key.jp.getStaticPart()))
//           if (jp.getStaticPart().toString().equals(key.jp.getStaticPart().toString()))
//            	System.out.println("Missmatch in JP Equalness");
        if (!jp.getStaticPart().toString().equals(key.jp.getStaticPart().toString()))
            return false;
        if ((jp.getTarget()==null)&&(key.jp.getTarget()!=null))
            return false;
        if (!jp.getTarget().equals(key.jp.getTarget()))
            return false;
        if ((jp.getThis()==null)&&(key.jp.getThis()!=null))
            return false;
        if (!jp.getThis().equals(key.jp.getThis()))
            return false;
        Object[] args=jp.getArgs();
        Object[] argsother=key.jp.getArgs();
        return equalsArrays(args,argsother);
    }

    private boolean equalsArrays(Object[] args, Object[] argsother) {
        if ((args==null)&&(argsother!=null))
            return false;
        if ((args!=null)&&(argsother==null))
            return false;
        if ((args==null)&&(argsother==null))
            return true;
        if ((args.length!=argsother.length))
            return false;
        for (int i = 0; i < argsother.length; i++) {
            if ((args[i]==null)&&(argsother[i]!=null))
                return false;
            if (args[i].equals(argsother[i]))
                continue;
        }
        return true;
    }

    public int hashCode() {
        if (jp!=null)
            return jp.getStaticPart().toString().hashCode();
        return super.hashCode();
    }
    
    public String toString(){
    	return "DefaultHashKey: "+hashCode()+" "+jp;
    }
    
}
