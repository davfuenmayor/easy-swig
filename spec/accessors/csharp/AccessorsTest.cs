using System;
using System.Runtime.InteropServices;
using accessors;

public class AccessorsTest {

  public static void Main()
   {
      Console.WriteLine("Accessors Test!");
      Accessors sut = new Accessors();
      sut.PropPrim = 18;
      if(sut.PropPrim != 18) {
      	throw new System.InvalidOperationException("PropPrim");
      }
      sut.PropEnum = Accessors.MyEnum.VAL_1;
      if(sut.PropEnum != Accessors.MyEnum.VAL_1) {
      	throw new System.InvalidOperationException("PropEnum");
      }
      sut.PropPtr = sut;
      if(sut.PropPtr.PropPrim != 18) {
      	throw new System.InvalidOperationException("PropPtr");
      }
      sut.PropString = "gato";
      if(sut.PropString.CompareTo("gato") != 0) {
      	throw new System.InvalidOperationException("PropString");
      }
      
      /// Unsafe
	  int num23 = 23;
	  int result;
      unsafe{
		  //int* v = &num23;
		  IntPtr ip = new IntPtr(&num23);
		  sut.PropPrimitivePtr = new SWIGTYPE_p_unsigned_char(ip, false);
		  
		  int* ret = (int *) HandleRef.ToIntPtr(SWIGTYPE_p_unsigned_char.getCPtr(sut.PropPrimitivePtr)).ToPointer();
		  result = *ret;
      }
      if(result != 23) {
		  	throw new System.InvalidOperationException("PropPrimitivePtr");
	  }
	  
      /// Static
      Accessors.StaticPropPtr = new Other();
      if(Accessors.StaticPropPtr == null) {
      	throw new System.InvalidOperationException("PropPtr");
      }
      Accessors.StaticPropString = "gato";
      if(Accessors.StaticPropString.CompareTo("gato") != 0) {
      	throw new System.InvalidOperationException("PropString");
      }
   }
}
