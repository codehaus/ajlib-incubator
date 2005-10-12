/*******************************************************************
 * Copyright (c) Arno Schmidmeier, AspectSoft
 * All rights reserved. 
 * This program and the accompanying materials are made available 
 * under the terms of the Common Public License v1.0 
 * which accompanies this distribution and is available at 
 * http://www.eclipse.org/legal/cpl-v10.html 
 *  
 * Contributors: 
 *     Arno Schmidmeier
 * ******************************************************************/

package org.codehaus.ajlib.util.ressourcecontroler;

import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;

public abstract aspect RessourceController {

	private Collection ressources2Free=new LinkedList();
	
	public abstract pointcut Workflow();
	
	public abstract pointcut ReceivingRessources();
	
	public abstract void free(Object obj);

	Object around():ReceivingRessources()&&cflow(Workflow()){
		Object toReturn=proceed();
		if ((toReturn!=null)&&!ressources2Free.contains(toReturn))
			ressources2Free.add(toReturn);
		return toReturn;
	}
	
	after():Workflow(){
		for (Iterator iter = ressources2Free.iterator(); iter.hasNext();) {
			Object ressource = iter.next();
			free(ressource);
		}
	}
}
