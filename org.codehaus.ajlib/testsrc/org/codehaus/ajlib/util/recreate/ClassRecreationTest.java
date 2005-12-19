package org.codehaus.ajlib.util.recreate;

import junit.framework.TestCase;

public class ClassRecreationTest extends TestCase {
    public void testClassRecreatorTest(){
        Creator creator=new Creator();
        creator.setup("User","Password");
        Object obj=creator.obj;
        Recreator.reSetup(obj,true);
        assertFalse(creator.obj.equals(obj));
    }
}

aspect ResetUp extends Recreator{
    public pointcut SettingAndCreatingMethods():
           execution(public Object+ Creator.setup(*,*));
}

class Creator{
    protected Object obj;
    
    public Object setup(String string, String string2) {
        obj=new Object();
        return obj;
    }
    
}
