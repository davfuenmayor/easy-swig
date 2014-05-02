#pragma once

namespace TestNamespace {

	typedef double * MyNamespaceDoublePtr;

	class Outer2 {};

	// Innerclasses
	class Outer {
		private:
			typedef float MyOuterClassFloat;
	
	protected:	
		class InnerProtected {
			public:
			int var;
			InnerProtected(int v = 0);
		};
		enum MyProtectedEnum{ 
			v1 = 0, v2, v3
		};
	
	public:
		
		enum MyEnum{ 
			value1 = 0, value2, value3
		};
		class Inner3 {
			protected:
			virtual int myFunc() = 0; 
		};
		
		class Inner2 {
		};
		class Inner4 { // Ignored: has no public constructor
			protected:
			Inner4(){};
		};
		class Inner5 { // Ignored: has no public destructor
			protected:
			~Inner5(){};
		};
	  	class Inner {
	  	
	  		typedef int MyInnerClassInt;
			public:
		  	MyOuterClassFloat outerFloatVar;
		  	MyInnerClassInt var;
		  	MyNamespaceDoublePtr nsDoubleVar;
		  	
			Inner(MyInnerClassInt v = 0);
			Inner2 useInner2(Inner2 const * inner2);
			const InnerProtected * useInnerProtected(const InnerProtected& innerProtected);
			MyEnum useMyEnum(MyEnum myEnum);
			void useMyProtectedEnum(MyProtectedEnum * myProtectedEnum){}
		};
	  
	  InnerProtected createInnerProtected(int num);
	  Inner createInner(int num);
	  void useInner(Inner& inner);	  
	  void useInnerProtected(InnerProtected& inner);
	  
	  void useOuter2(Outer2& outer2){}
	};
}


