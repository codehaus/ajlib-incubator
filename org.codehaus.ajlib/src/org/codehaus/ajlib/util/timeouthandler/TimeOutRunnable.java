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

package org.codehaus.ajlib.util.timeouthandler;

public abstract class TimeOutRunnable implements Runnable {
    protected TimeOutRunnable(ResultsReceiver toWakeUp){
        this.toWakeUp=toWakeUp;
    }
    
    private ResultsReceiver toWakeUp;
        
    public abstract Object proceeding();
    
    public void start(){
        new Thread(this).start();
    }
    
    public void run(){
        Object toReturn=null;
        try {
            toReturn = proceeding();
        } catch (RuntimeException e) {
            toWakeUp.setRuntimeException(e);
        }
        toWakeUp.setResult(toReturn);
    }
}
