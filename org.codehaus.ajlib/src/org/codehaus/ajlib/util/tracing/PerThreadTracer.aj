package org.codehaus.ajlib.util.tracing;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;

import org.codehaus.ajlib.error.AspectConfigurationException;

public aspect PerThreadTracer extends PrintStreamTracer {

	private ThreadLocal printStreamHolder = new ThreadLocal() {
		public Object initialValue() {
			String fileName = null;//"trace."+Thread.currentThread().getName()+".log";
			FileOutputStream fos;
			
			fileName = "C:/temp/trace."+Thread.currentThread().hashCode()+".log";
			try {
				fos = new FileOutputStream(fileName);
			} catch (FileNotFoundException e2) {					
				System.err.println("Can't open "+fileName);
				e2.printStackTrace();
				throw new AspectConfigurationException("Can't construct print stream");
				//throw new AspectConfigurationException("Can't construct print stream", e);
			}
			try {
				System.err.println("Logging thread "+Thread.currentThread().getName()+" to "+(new File(fileName)).getAbsolutePath());
			} catch (Exception e) {}
			return new PrintStream(fos);
		}
	};
	
	public PrintStream getPrintStream() {
		return (PrintStream)printStreamHolder.get();		
	}
	//TODO: flush & close when idle
}
