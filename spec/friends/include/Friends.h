#pragma once
#include <string>


namespace TestNamespace {

	int friendFunction() {
        return 5;
    }

	class Vector {
	
	public:
		float x, y;
		
		Vector();

        inline Vector( const float fX, const float fY) : x( fX ), y( fY ){}

		inline friend Vector operator + (const Vector& lhs, const float rhs) {
            return Vector(lhs.x + rhs,lhs.y + rhs);
        }
        
        inline friend Vector operator- (const Vector& lhs, const float rhs) {
            return Vector(lhs.x - rhs,lhs.y - rhs);
        }
        
        inline friend Vector operator- (const Vector& lhs) {
            return Vector(-lhs.x,-lhs.y);
        }
        
        inline friend Vector operator* (const Vector& lhs, const float rhs) {
            return Vector(lhs.x * rhs,lhs.y * rhs);
        }
        
        inline friend int friendFunction();
	};
}


