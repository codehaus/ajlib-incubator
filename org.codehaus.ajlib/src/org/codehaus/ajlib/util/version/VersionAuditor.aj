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

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Map;
 

/**
 * A generic aspects which checks if all public loaded classes have a version tag; 
 * if a public class has a version tag, it retrieves it, and handle the class 
 * and the version tag over to an class version audit hook.
 * If no version tag is found, it audits also this fact via a different handler. <p/>
 * 
 * This aspect is implemented as an abstract aspect. This ensures that no class 
 * version checks are performed. All classes, which have a version tag 
 * are collected in a hashmap. This approach has some benefits: <ul>
 * <li>You can retrieve at anytime all versions of the loaded classes.</li> 
 * <li>You do not get double class version audit messages</li>
 * </ul>
 * However this approach has one drawback, classes with a version tag 
 * are never collected by the class garbage collector.  
 *   
 * <p/>
 * Usage: <ul>
 * <li>Subclass this aspect, and provide a concrete pointcut definition for @see ourClassInitialization</li>   
 * <li>realise your own auditing policies by overwriting or advising the auditing hook methods 
 * (@see logVersion , @see writeVersionMessage , @see warnNoClazz).</li>
 </ul> 
 *
 * A version tag of a class must fullfill following conditions: <ul>
 * <li>it must be declared as public static final String </li>
 * <li>The version tagname must contain a version pattern. The default keyword is "Version". 
 * You can change this behaviour by overwriting getVERSION_PATTERN @see getVERSION_PATTERN</li>
 * </ul>
 *     
 * @author Arno Schmidmeier
 * @since ajlib 0.1 
 */
public abstract aspect VersionAuditor {	

	public abstract pointcut ourClassInitialization();
	
	private pointcut staticclassinit():staticinitialization(*);
	
    /**
     * This method returns the version pattern. 
     * Overwrite this method to change the default name pattern.
     * @return the default version pattern, default "Version"  
     */
	public String getVERSION_PATTERN() {
		return VERSION_PATTERN;
	}
	
	static private final String VERSION_PATTERN="Version"; 
	
	after():staticclassinit()&&!within(VersionAuditor*+)&&ourClassInitialization(){
		Class clazz=thisJoinPoint.getSignature().getDeclaringType();
		debug(clazz+" found");
		handleClass(clazz);
	}
	
    /**
     * returns a map, which contain all classes with version tags. 
     * The keys are the classes, the values are the versions.
     */
    public final Map getClazzesMap(){
        return clazzes;
    }
    
    protected Map clazzes=new HashMap(); 
	
	public void handleClass(Class clazz) {
		if (clazz==null)
			return;
		if (clazzes.containsKey(clazz))
			return;
		int classmodifiers=clazz.getModifiers();
		if (!Modifier.isPublic(classmodifiers)){
			debug("clazz is not Public");
			return;
		}
		if (clazz.isAnonymousClass()){
			debug("clazz is Anonymous");
			return;
		}
		if (clazz.isArray())
			return;
		if (clazz.toString().indexOf('$')>-1){
			debug("clazz seems to be an inner class");
			return;
		}
		Field fields[]=clazz.getDeclaredFields();
		String version_pattern = getVERSION_PATTERN();
		for (int i = 0; i < fields.length; i++) {
			Field field = fields[i];
			String name=field.getName();
			int modifieres=field.getModifiers();
			if (!(
					Modifier.isPublic(modifieres)
					&&Modifier.isFinal(modifieres)
					&&Modifier.isStatic(modifieres)
					)
			    )
				continue;
			Class clazztype=field.getType();
			if (clazztype.equals(String.class)){
				try {
					String value=(String) field.get(null);
					if (value==null)
						continue;
					if (name.indexOf(version_pattern)>-1){
						clazzes.put(clazz,value);
						logVersion(clazz,value);
						return;
					}
				} catch (IllegalAccessException e) {
				}
			}else
				debug("OtherClass: "+clazztype.getName());
		}
		warnNoClazz(clazz," has no Version Tag");
	}
	
    /**
     * hook method for debug output messages 
     */
	protected void debug(String message){
	}
	
    /**
     * hook method for logging the Version. The default implementation
     * creates a version String consisting of the classname the token " has Version: " and the version tag.
     * This string is then forwarded to @see writeVersionMessage
     */
    protected void logVersion(Class clazz,String message){
		StringBuffer sb=new StringBuffer(clazz.toString());
		sb.append(" has Version: ");
		sb.append(message);
		writeVersionMessage(sb.toString());
	}
	
    /**
     * Hook method for output of the Version messge. 
     * Overwrite for your own auditing policy.
     * There is no default implementation.   
     */
    protected void writeVersionMessage(String message){	
	}

    /**
     * Hook method for output of missing version tags.  
     * Overwrite for your own auditing policy.
     * There is no default implementation.   
     */
    protected void warnNoClazz(Class clazz,String message){
	}
	
}
