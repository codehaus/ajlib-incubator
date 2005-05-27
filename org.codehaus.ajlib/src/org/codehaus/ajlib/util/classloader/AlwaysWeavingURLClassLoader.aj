/*******************************************************************
 * Copyright (c) New Aspects on Software.
 * All rights reserved. 
 * This program and the accompanying materials are made available 
 * under the terms of the Common Public License v1.0 
 * which accompanies this distribution and is available at 
 * http://www.eclipse.org/legal/cpl-v10.html 
 *  
 * Contributors: 
 *     Ron Bodkin
 * ******************************************************************/
package org.codehaus.ajlib.util.classloader;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.CodeSource;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.aspectj.weaver.WeavingURLClassLoader;

/**
 * Subclass of the AspectJ 1.2+ weaving url classloader. This version weaves
 * into classes loaded through its parents, rather than requiring that they not
 * have visibility into the classes on its classpath... This implementation is
 * just the dreaded non-delegating classloader. It would be nice if we had a
 * Java 1.5-style instrumentation hook instead...
 */

public class AlwaysWeavingURLClassLoader extends WeavingURLClassLoader {
	public static String className = AlwaysWeavingURLClassLoader.class.getName();

	public static final boolean traceEnabled = Boolean.getBoolean(className + ".trace");

	/*
	 * This constructor is needed when using "-Djava.system.class.loader"
	 */
	public AlwaysWeavingURLClassLoader(ClassLoader parent) {
		this(getURLs(getClassPath()), getURLs(getAspectPath()), parent);
		if (traceEnabled) {
			System.err.println("? " + className + ".<init>(" + parent
					+ "), # URLs = " + getURLs().length);
		}
	}

	public AlwaysWeavingURLClassLoader(URL[] classURLs, URL[] aspectURLs, ClassLoader parent) {
		super(classURLs, aspectURLs, parent);
		if (traceEnabled) {
			System.err.println("? " + className + ".<init>()");
		}
	}

	// some lovely copy/paste reuse since these methods aren't protected :-(
	private static String getAspectPath() {
		return System.getProperty(WEAVING_ASPECT_PATH, "");
	}

	private static String getClassPath() {
		String clpath = System.getProperty(WEAVING_CLASS_PATH, "");
		if ("".equals(clpath)) {
			clpath = System.getProperty("java.class.path", ".");
			String apath = getAspectPath();
			if (!("".equals(apath))) {
				clpath = apath + System.getProperty("path.separator", ":")
						+ clpath;
			}
		}
		return clpath;
	}

	private static URL[] getURLs(String path) {
		List urlList = new ArrayList();
		for (StringTokenizer t = new StringTokenizer(path, File.pathSeparator); t.hasMoreTokens();) {
			String token = t.nextToken().trim();
			File f = new File(token);
			try {
				if (f.exists()) {
					URL url = f.toURL();
					if (url != null)
						urlList.add(url);
				}
			} catch (MalformedURLException e) {
			}
		}

		URL[] urls = new URL[urlList.size()];
		urlList.toArray(urls);
		return urls;
	}

	public Class loadClass(String name)
			throws ClassNotFoundException {
		if (name.startsWith("java.") || name.startsWith("javax.") || name.startsWith("sun.") ||
		  name.startsWith("com.sun.") || name.startsWith("org.xml") || name.startsWith("org.w3c")) {
			return super.loadClass(name);
		}
		if (traceEnabled) {
			System.err.println("? " + className + ".loadClass(" + name + ")");
		}

		Class c = findLoadedClass(name);
		if (c == null) {
			try {
				c = findClass(name);
			} catch (ClassNotFoundException e) {
				return getParent().loadClass(name);
			}
		}

		return c;
	}

	protected Class defineClass(String name, byte[] b, CodeSource cs) throws IOException {
		if (traceEnabled) {
			System.err.println("? "+className+".defineClass(" + name + ", [" + b.length + "])");
		}
		Class c = super.defineClass(name, b, cs);
		return c;
	}

	protected Class findClass(String name) throws ClassNotFoundException {
		if (traceEnabled) {
			System.err.print("? " + className + ".findCass(" + name + ")");
		}
		Class clazz = super.findClass(name);
		if (traceEnabled) {
			System.err.println("found = " + (clazz != null));
		}
		return clazz;
	}

	public URL getResource(String name) {
		if (name.startsWith("java/") || name.startsWith("javax/") || name.startsWith("sun/") ||
		  name.startsWith("com/sun/") || name.startsWith("org/xml/") || name.startsWith("org/w3c/")) {
			return super.getResource(name);
		}

		if (traceEnabled) {
			System.err.print("? " + className + ".getResource(" + name + ")");
		}
		URL url = findResource(name);
		if (url != null) {
			if (traceEnabled) {
				System.err.println("found: " + url);
			}
			return url;
		}

		if (traceEnabled) {
			System.err.println("not found");
		}
		return getParent().getResource(name);
	}

}
