using System;
using anonymousEnums;

public class AnonymousEnumsTest {
  
  public static void Main()
   {
      Console.WriteLine("AnonymousEnums Test!");
      AnonymousEnums sut = new AnonymousEnums();
      sut.AMethod((int) AnonymousEnums_Enum.value3);
      if(anonymousEnums.anonymousEnums.NsFunction() != (int) AnonymousEnums_Enum.value3) {
      	throw new System.InvalidOperationException("Value should be equal to value3");
      }
      sut.AMethod((int) ns_TestNamespace_Enum.noClassvalue3);
      if(anonymousEnums.anonymousEnums.NsFunction() != (11|15)) {
      	throw new System.InvalidOperationException("Value should be equal to 15");
      }
      
   }

}
