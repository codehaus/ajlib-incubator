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

import junit.framework.TestCase;

public class RessourceControllerTestCase extends TestCase {
	private RessourceControllerTestAspect.Closeable closeable;
	
	public void testRessourceUsage(){
		doTestWorkflow();
	}

	private void doTestWorkflow() {
		RessourceControllerTestAspect.Closeable obj=getRessource();
		assertFalse("Obj not closed",obj.isClosed());
	}
	
	private RessourceControllerTestAspect.Closeable getRessource(){
		closeable=new RessourceControllerTestAspect.Closeable(){
			private boolean closed=false;
			
			public boolean isClosed() {
				return closed;
			};
			
			public void close() {
				closed=true;
			};
		};
		return closeable;
	}
}
