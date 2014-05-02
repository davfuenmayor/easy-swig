#pragma once
#include <string>
#include <vector>

namespace TestNamespace {

using namespace std;

	class string { // Yes, we define our own string class. Bad bad practice..
	public:
	  int compare (const string& str) const;
	};
	
	template <class K, class V> class map { // Yes, and map too!
	public:
	  int compare (const map<K, V>& arg) const;
	};
	
	class Klass1 {
	};
	
	class Klass2 {
	};
	
	class NamespacePrefixes {
		
		public:
	  	int compareString (const TestNamespace::string& str) const;
	  	int compareStringNoNS (const string& str) const;
	  	int compareStringSTL (const std::string& str) const;
	  	
	  	std::vector<int> withPrefix (const std::vector<Klass1>& vector) const;
	  	vector<int> noPrefix (const vector<Klass2>& vector) const;
		int compareMapSTL (const std::map<int, int>& map) const;
	};
}


