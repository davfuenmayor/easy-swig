#include "Innerclasses.h"

namespace TestNamespace {

	// Innerclasses
	Outer::Inner::Inner(Inner::MyInnerClassInt v) {
		  	var = v;
	}
	Outer::InnerProtected::InnerProtected(int v) {
		  	var = v;
	}
	Outer::Inner Outer::createInner(int v){
		  	Inner * ret = new Inner(v);
		  	return *ret;
	}
	Outer::InnerProtected Outer::createInnerProtected(int v){
		  	InnerProtected * ret = new InnerProtected(v);
		  	return *ret;
	}
	void Outer::useInner(Inner& inner){
	  	inner.var += 100;
	}
	void Outer::useInnerProtected(InnerProtected& innerprotected){
	  	innerprotected.var += 100;
	}
	Outer::Inner2 Outer::Inner::useInner2(Outer::Inner2 const * inner2){
	  	return *inner2;
	}
	const Outer::InnerProtected * Outer::Inner::useInnerProtected(const Outer::InnerProtected& innerProtected){
		const InnerProtected* innerProtectedPtr = &innerProtected;
	  	return innerProtectedPtr;
	}
	
	Outer::MyEnum Outer::Inner::useMyEnum(Outer::MyEnum myEnum){
		return myEnum;
	}
}


