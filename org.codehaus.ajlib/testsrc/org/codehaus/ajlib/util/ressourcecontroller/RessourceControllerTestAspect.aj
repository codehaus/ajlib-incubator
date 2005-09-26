/*******************************************************************
 * Copyright (c) AspectSoft
 * All rights reserved. 
 * This program and the accompanying materials are made available 
 * under the terms of the Common Public License v1.0 
 * which accompanies this distribution and is available at 
 * http://www.eclipse.org/legal/cpl-v10.html 
 *  
 * Contributors: 
 *     Arno Schmidmeier
 * ******************************************************************/


package org.codehaus.ajlib.util.ressourcecontroller;

import org.codehaus.ajlib.util.ressourcecontroler.RessourceController;

public aspect RessourceControllerTestAspect extends RessourceController {
	interface Closeable{
		
		public void close();
		
		public boolean isClosed();
	}
	
	public pointcut Workflow():execution(* RessourceControllerTestCase.doTestWorkflow());

	public pointcut ReceivingRessources():execution(* RessourceControllerTestCase.getRessource());

	public void free(Object obj){
		((Closeable) obj).close();
	}
}