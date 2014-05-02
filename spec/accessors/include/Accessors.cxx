#include "Accessors.h"

namespace TestNamespace {

		Other* Accessors::propPtrStatic = new Other();
		Other Accessors::propValStatic = *Accessors::propPtrStatic;
		std::string Accessors::propStringStatic = "";

		// Pointer	
		TestNamespace::string Accessors::getPropOwnString(){ return propOwnString; }
		void Accessors::setPropOwnString(TestNamespace::string obj){ propOwnString = obj; }
		
		// Pointer	
		float Accessors::getPropPrim(){	return propPrim; }
		void Accessors::setPropPrim(float obj){	propPrim = obj; }
		
		// Pointer	
		Accessors::MyEnum Accessors::getPropEnum(){ return propEnum; }
		void Accessors::setPropEnum(Accessors::MyEnum obj){ propEnum = obj; }
		
		// Pointer	
		Accessors::AccessorsPtr Accessors::getPropPtr(){ return propPtr; }
		void Accessors::setPropPtr(Accessors *obj){ propPtr = obj; }
			
		// Value (Ignored)	
		Accessors Accessors::getPropVal(){ return *propVal; }
		void Accessors::setPropVal(Accessors obj){ propVal = &obj; }
		
		// Reference (Ignored)	
		Accessors::AccessorsRef Accessors::getPropRef(){ return *propRef; }
		void Accessors::setPropRef(Accessors &obj){ *propRef = obj; }
		
		// string
		std::string Accessors::getPropString(){ return propString; }
		void Accessors::setPropString(std::string obj){ propString = obj; }
		
		Accessors::uchar* Accessors::getPropPrimitivePtr(void){ 
			return propPrimitivePtr;
		}
		
		void Accessors::setPropPrimitivePtr(Accessors::ucharPtr arg){
			propPrimitivePtr = arg;
		}
		
		
		////// Static getters and setters
		
		// Pointer
		Other* Accessors::getStaticPropPtr(){ return propPtrStatic; }
		void Accessors::setStaticPropPtr(Other *obj){ propPtrStatic = obj; }
		
		// Value (Ignored)
		Other Accessors::getStaticPropVal(){ return propValStatic;}
		void Accessors::setStaticPropVal(Other obj){ propValStatic = obj; }
		
		// Reference (Ignored)
		Other Accessors::getStaticPropRef(){ return (Other)Accessors::getStaticPropVal(); }
		void Accessors::setStaticPropRef(Other &obj){ }
		
		// Pointer
		std::string Accessors::getStaticPropString(){ return propStringStatic; }
		void Accessors::setStaticPropString(std::string obj){ propStringStatic=obj; }

}
