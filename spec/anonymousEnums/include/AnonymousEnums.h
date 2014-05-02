#pragma once

enum { // Out of any Namespace
			noNSvalue1, noNSvalue2, noNSvalue3
};

namespace TestNamespace {
	
	int nsVar;
	int nsFunction();
	
	enum { // Out of any Class
		noClassvalue1 = 11, noClassvalue2 = noClassvalue1 + 4, noClassvalue3 = noClassvalue1 | noClassvalue2
	};
	
	class AnonymousEnums {
	
		public:
	
		enum { 
			value1 = 23, value2 = 24, value3 = value1 + value2
		};
		
		void aMethod(int x);
	};
	
}


