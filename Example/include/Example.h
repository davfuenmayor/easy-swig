#pragma once
#include <map>
#include <string>
#include "util/macros.h"	// Macros INT, STRING, FLOAT, INLINE, FORCE_INLINE
#include "util/typedefs.h"	// Typedefs DoublePtr, IntPtr, CharPtr
#include "common/structs.h"	// Struct1, Struct2, Struct3

namespace Example {

using namespace std;

enum MyEnum{ 											// Named Enum with values is wrapped
	value1 = 0, value2, value3
};

struct WrappedStruct {}; 								// Class is wrapped
class NotWrappedClass {};

STRING globalVar; 										// Global variables are wrapped

int friendFunction() {
    return 5;
}

class ExampleClass {

	protected:
	class ProtectedInnerClass {}; 						// Innerclass is not visible from outside
	int myProtectedMethod();							// Method not wrapped	

	public:
	
	static MyEnum staticVar;							// Public static attributes are also wrapped
	
	ExampleClass(FLOAT v = 0);
	
	
	/***** 1. Anonymous Enums *******/
	
	enum { 												// Anonymous Enum with values is wrapped
		value1 = 11, value2 = 22, value3 = value1 + value2
	};
	
	
	/***** 2. Inner- Classes and Structs *******/

	class InnerStruct {};								// Innerstruct is wrapped
	class InnerClass {
		typedef int MyInnerClassInt;					// private typedef is found and expanded
		public:
		int var;										// Public attributes are also wrapped
		InnerClass(MyInnerClassInt v = 0); 				// public methods found and expanded
		MyEnum useMyEnum(MyEnum myEnum);
	};	  
	INLINE void useInnerClass(InnerClass& inner, CharPtr);	// Method is wrapped  
	void useWrappedStruct(WrappedStruct& ws, DoublePtr d){}	// Method is wrapped
	void useInnerProtected(ProtectedInnerClass& inner); 		// Method is public but is not wrapped
	
	
	/***** 3. Friend fuctions and operator overloading *******/

	FORCE_INLINE friend int friendFunction();					// Friend function found and wrapped
	FORCE_INLINE friend ExampleClass operator + (const ExampleClass& lhs, const FLOAT num) {	// Overloaded operator found and wrapped
		return ExampleClass(friendFunction() + num);
	}
	
	
	/***** 4. Accessors: Getters and Setters -> Properties *******/
	
	double getPropPtr();									// Wrapped as a property named PropPtr
	void setPropPtr(double obj);	
	static STRING getStaticPropString(); 					// Wrapped as a static property named StaticPropString
	static void setStaticPropString(string obj);
	
	
	/***** 5. Templates (and nested typedef expansion) *******/	
	
	typedef map<int,WrappedStruct> TemplateTypedef;	// Automatically instantiated
	void methodWithTemplateParam(TemplateTypedef p);			// Correctly wrapped
};
}


