/* File : standard_header.i */
#ifndef STANDARDHEADER_I
#define STANDARDHEADER_I

#ifdef FORCEINLINE
	#undef FORCEINLINE
#endif
#define FORCEINLINE inline


#ifdef _GLIBCXX_VISIBILITY
#undef _GLIBCXX_VISIBILITY
#endif
#define _GLIBCXX_VISIBILITY(var)


#ifdef _GLIBCXX_NORETURN
#undef _GLIBCXX_NORETURN
#endif
#define _GLIBCXX_NORETURN

#ifdef _GLIBCXX_BEGIN_NAMESPACE_VERSION
#undef _GLIBCXX_BEGIN_NAMESPACE_VERSION
#endif
#define _GLIBCXX_BEGIN_NAMESPACE_VERSION

#ifdef _GLIBCXX_END_NAMESPACE_VERSION
#undef _GLIBCXX_END_NAMESPACE_VERSION
#endif
#define _GLIBCXX_END_NAMESPACE_VERSION


#ifdef _GLIBCXX_BEGIN_NAMESPACE_CONTAINER
#undef _GLIBCXX_BEGIN_NAMESPACE_CONTAINER
#endif
#define _GLIBCXX_BEGIN_NAMESPACE_CONTAINER

#ifdef _GLIBCXX_END_NAMESPACE_CONTAINER
#undef _GLIBCXX_END_NAMESPACE_CONTAINER
#endif
#define _GLIBCXX_END_NAMESPACE_CONTAINER

#ifdef _GLIBCXX_CONSTEXPR
#undef _GLIBCXX_CONSTEXPR
#endif
#define _GLIBCXX_CONSTEXPR

#ifdef _GLIBCXX_USE_CONSTEXPR
#undef _GLIBCXX_USE_CONSTEXPR
#endif
#define _GLIBCXX_USE_CONSTEXPR const

%include "std_string.i"
%include "std_vector.i"
%include "std_map.i"
%include "std_pair.i"
%include "std_common.i"
%include "std_shared_ptr.i"
%include "std_deque.i"
%include "std_wstring.i"
%include "wchar.i"
%include "arrays_csharp.i"
%include "typemaps.i"

/* ------------------------------------------------------------
 * Overloaded operator support
 * ------------------------------------------------------------ */

#ifdef __cplusplus

%rename(__add__)      *::operator+;
%rename(__pos__)      *::operator+();
%rename(__pos__)      *::operator+() const;
%rename(__sub__)      *::operator-;
%rename(__neg__)      *::operator-();
%rename(__neg__)      *::operator-() const;
%rename(__mul__)      *::operator*;
%rename(__div__)      *::operator/;
%rename(__mod__)      *::operator%;
%rename(__lshift__)   *::operator<<;
%rename(__rshift__)   *::operator>>;
%rename(__and__)      *::operator&;
%rename(__or__)       *::operator|;
%rename(__xor__)      *::operator^;
%rename(__invert__)   *::operator~;
%rename(__lt__)       *::operator<;
%rename(__le__)       *::operator<=;
%rename(__gt__)       *::operator>;
%rename(__ge__)       *::operator>=;
%rename(__eq__)       *::operator==;

/* Special cases */
%rename(__call__)     *::operator();

/* Ignored inplace operators */
%ignoreoperator(NOTEQUAL)   operator!=;  
%ignoreoperator(PLUSEQ)     operator+=;  
%ignoreoperator(MINUSEQ)    operator-=;  
%ignoreoperator(MULEQ)      operator*=;  
%ignoreoperator(DIVEQ)      operator/=;  
%ignoreoperator(MODEQ)      operator%=;  
%ignoreoperator(LSHIFTEQ)   operator<<=; 
%ignoreoperator(RSHIFTEQ)   operator>>=; 
%ignoreoperator(ANDEQ)      operator&=;  
%ignoreoperator(OREQ)       operator|=;  
%ignoreoperator(XOREQ)      operator^=;  

/* Ignored operators */
%ignoreoperator(LNOT)       operator!;
%ignoreoperator(LAND)       operator&&;
%ignoreoperator(LOR)        operator||;
%ignoreoperator(EQ)         operator=;
%ignoreoperator(PLUSPLUS)   operator++;
%ignoreoperator(MINUSMINUS) operator--;
%ignoreoperator(ARROWSTAR)  operator->*;
%ignoreoperator(INDEX)      operator[];


#endif /* __cplusplus */

/* Typemaps Definitions for all possible combinations of pointers/refs
 	bool               *INOUT, bool               &INOUT
        signed char        *INOUT, signed char        &INOUT
        unsigned char      *INOUT, unsigned char      &INOUT
        short              *INOUT, short              &INOUT
        unsigned short     *INOUT, unsigned short     &INOUT
        int                *INOUT, int                &INOUT
        unsigned int       *INOUT, unsigned int       &INOUT
        long               *INOUT, long               &INOUT
        unsigned long      *INOUT, unsigned long      &INOUT
        long long          *INOUT, long long          &INOUT
        unsigned long long *INOUT, unsigned long long &INOUT
        float              *INOUT, float              &INOUT
        double 
*/
/*
%apply signed char *INPUT { signed char *, signed char &};
%apply unsigned char *INPUT { unsigned char *, unsigned char &};
%apply float *INPUT { float *, float &};
%apply bool *INPUT { bool *, bool &};
%apply unsigned short *INPUT { unsigned short *, unsigned short &};
%apply short *INPUT { short *, short &};
%apply int *INPUT { int *, int &};
%apply unsigned int *INPUT { unsigned int *, unsigned int &};
%apply long *INPUT { long *, long &};
%apply long long *INPUT { long long *, long long &};
%apply double *INPUT { double *, double &};
%apply unsigned long *INPUT { unsigned long *, unsigned long &};
%apply unsigned long long *INPUT { unsigned long long *, unsigned long long &};*/


// Typemaps Definitions for Strings
%apply const std::string& {std::string* };

using namespace std;

%{
using namespace std;
%}

#endif
