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


package org.codehaus.ajlib.util.recreate;

import java.util.Hashtable;

public abstract aspect Recreator {
    public abstract pointcut SettingAndCreatingMethods();
        
    interface ProceedCommand{
        public Object doProceed();
    }
    
    protected static Hashtable proceedObjects=new Hashtable();
    
    public static void reSetup(Object obj,boolean cleanup){
        if (obj==null)
            return;
        ProceedCommand command=(ProceedCommand) proceedObjects.get(obj);
        if (command==null)
            return;
        Object newkey=command.doProceed();
        if (cleanup)
            proceedObjects.remove(obj);
        proceedObjects.put(newkey,command);
    }

    
    Object around():SettingAndCreatingMethods(){
        ProceedCommand command=new ProceedCommand(){
            public Object doProceed(){
                return proceed();
            }
        };
        Object obj=command.doProceed();
        if (obj!=null)
            proceedObjects.put(obj,command);
        return obj;
    }
}
