#include "Example.h"

namespace Example {

	ExampleClass::InnerClass::InnerClass(InnerClass::MyInnerClassInt v) {
	  	var = v;
	}
	MyEnum ExampleClass::InnerClass::useMyEnum(MyEnum e) {
		staticVar = e;
	  	return e;
	}
	// No need to define other methods (see other examples in spec/ folder for actual use)
}




