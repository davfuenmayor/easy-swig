using System;
using innerclasses;

public class InnerclassesTest {
  
  public static void Main()
   {
      Console.WriteLine("InnerClasses Test!");
      Outer outer = new Outer();
      Outer.Inner inner = outer.CreateInner(45);
      if(inner.var != 45) {
      	throw new System.InvalidOperationException("Inner value should be initially 45");
      }
      outer.UseInner(inner);
      if(inner.var != 145) {
      	throw new System.InvalidOperationException("Inner value should be 145 after UseInner()");
      }
   }
}
