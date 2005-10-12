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

package org.codehaus.ajlib.util.version;

import java.util.HashMap;
import java.util.Map;

import junit.framework.TestCase;

public class VersionTester extends TestCase {
	static aspect MyVersionTester extends VersionAuditor{
		public pointcut ourClassInitialization():staticinitialization(org.codehaus.ajlib.util.version.*)&&
			!staticinitialization(org.codehaus.ajlib.util.version.VersionAuditor)
			&&	!staticinitialization(org.codehaus.ajlib.util.version.*ester*);
		
		private pointcut staticclassinit():staticinitialization(*);
		
		public String getVERSION_PATTERN() {
			return "Revision";
		}
		
		Map noClassList=new HashMap();
		
		protected void warnNoClazz(Class clazz,String message){
			noClassList.put(clazz,message);
		}

	}
	
	public void testDefaultClassWithVersion(){
		new DefaultClassWithNoVersion();
		Map clazzmap=MyVersionTester.aspectOf().getClazzesMap();
		assertTrue("No Default classes in the list",!clazzmap.containsKey(DefaultClassWithNoVersion.class));
	}

	public void testPublicClassWithVersions(){
		new PublicClassWithVersion();
		Map clazzmap=MyVersionTester.aspectOf().getClazzesMap();
		assertTrue("Public Classes in the list",clazzmap.containsKey(PublicClassWithVersion.class));
		assertTrue("Public Classes in the list",clazzmap.get(PublicClassWithVersion.class).equals(PublicClassWithVersion.PublicClassWithVersion_Revision));
	}
	
	public void testPublicClassWithNoVersions(){
		new PublicClassWithNoVersion();
		Map clazzmap=MyVersionTester.aspectOf().getClazzesMap();
		assertTrue("Public Classes with no Version Tag",!clazzmap.containsKey(PublicClassWithNoVersion.class));
		assertTrue("No Version Message written",MyVersionTester.aspectOf().noClassList.containsKey(PublicClassWithNoVersion.class));
	}

	public void testPublicInnerClassWithVersions(){
		new PublicClassWithVersion.InnerClass();
		Map clazzmap=MyVersionTester.aspectOf().getClazzesMap();
		assertTrue("No inner in the list",!clazzmap.containsKey(PublicClassWithVersion.InnerClass.class));
	}
	
}
