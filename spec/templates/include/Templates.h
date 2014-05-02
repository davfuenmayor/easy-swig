#pragma once
#include <vector>
#include <map>
#include <string>


namespace TestNamespace {

	using namespace std;

	class MyClass {};	
	class MyOtherClass {};		
	class NonWrappedClass {};

	class Templates {
	  public:
	  
	  	typedef vector<const int *> TemplTypedef;
	  	typedef pair<string, TemplTypedef> * PairStrTemplTypedef;
	  	typedef std::map<char*,MyClass> MyTypedef2;
	  	typedef MyTypedef2 * MyTypedef;
	  	typedef vector<MyOtherClass *> & VectorMyOtherClassRef;
	  
		vector<unsigned int> method1(vector<MyClass> &);
		vector<unsigned int> method2(MyTypedef &);
		vector<NonWrappedClass *> method3(VectorMyOtherClassRef);
		void method4(PairStrTemplTypedef);
	};
}


