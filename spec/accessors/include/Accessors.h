#pragma once
#include <string>


namespace TestNamespace {

	using namespace std;
	
	class string {};
	
	class Other {};

	class Accessors {
	
		public:
		
		typedef unsigned char uchar;
		typedef uchar * ucharPtr;
		
		Accessors(){}
		
		enum MyEnum
		{
            VAL_1,	VAL_2,  VAL_3,  VAL_4
		};
	
		typedef Accessors* AccessorsPtr;
		typedef Accessors& AccessorsRef;
		
		// Pointer	
		TestNamespace::string getPropOwnString();
		void setPropOwnString(TestNamespace::string obj);
		
		// Pointer	
		float getPropPrim();
		void setPropPrim(float obj);
		
		// Pointer	
		MyEnum getPropEnum();
		void setPropEnum(MyEnum obj);			
		
		// Pointer	
		AccessorsPtr getPropPtr();
		void setPropPtr(Accessors *obj);
			
		// Value Ignored
		Accessors getPropVal();
		void setPropVal(Accessors obj);
		
		// Reference Ignored	
		AccessorsRef getPropRef();
		void setPropRef(Accessors &obj);
		
		// string
		std::string getPropString();
		void setPropString(std::string obj);
		
		ucharPtr getPropPrimitivePtr(void);
		void setPropPrimitivePtr(uchar*);
		
		// Static
		
		static Other* getStaticPropPtr(); // Pointer	
		static void setStaticPropPtr(Other *obj);
			
		static Other getStaticPropVal(); // Value Ignored
		static void setStaticPropVal(Other obj);
			
		static Other getStaticPropRef(); // Reference Ignored
		static void setStaticPropRef(Other &obj);
		
		static std::string getStaticPropString(); // string
		static void setStaticPropString(std::string obj);
		
		private:
		
		TestNamespace::string propOwnString;
		float propPrim;
		MyEnum propEnum;
		AccessorsPtr propPtr;
		Accessors* propVal;
		Accessors* propRef;
		std::string propString;
		unsigned char *	propPrimitivePtr;
		
		static Other* propPtrStatic;
		static Other propValStatic;
		static std::string propStringStatic;
		
	};
		
}


