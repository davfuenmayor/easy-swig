EasySwig
=========

Automatically generates wrappers for C/C++ code using SWIG.

This is both a Ruby Gem and a CLI Tool. Feed it with a directory containing the library's header files (the ones you want to wrap) and a CSV File with basic configuration (see usage). EasySwig will generate the corresponding SWIG interface files (.i) in an output directory. EasySwig also offers a facade allowing you to directly call SWIG in order to generate wrappers in the target language.

EasySwig supports currently only C#. There is  ongoing work on other languages support.


Installation and Use
------------

EasySwig relies on the Doxyparser gem (https://github.com/davfuenmayor/ruby-doxygen-parser) which on his part depends on Nokogiri (http://nokogiri.org) and Doxygen (www.doxygen.org). Refer to Doxyparser for more information.

To actually generate wrappers you may also want to install SWIG (http://www.swig.org/). SWIG versions 2.x and 3.x are supported.


For using EasySwig you need to create a folder with the following structure:
(it is recommended to use the subfolder 'spec/Example' as a template)

- A subfolder named 'include' with the header files you want to wrap.
- A CSV file named 'api.csv' with the name of the namespace you want to wrap and which members to wrap/ignore. See below.
- An optional file (optionally named custom_config.i) with %include statements for those header files found in subdirectories (otherwise SWIG won't find them)

There are three operations you can do with EasySwig: 'doxygen', 'generate' and 'swig'
1. doxygen: Generate Doxygen XML intermediate representation. Here you need the Doxyparser gem installed on your system.
2. generate: Generate SWIG Interface Files (.i) from the previously generated Doxygen XML intermediate representation
3. swig: Generate wrappers from your header files and the previously generated .i files. Here you need SWIG installed on your system.


As Ruby Gem
-----------

```shell
gem install doxyparser
```
or add the following line to your Gemfile:

```ruby
gem 'doxyparser'
```
and run `bundle install` from your shell.

Call EasySwig from your Ruby code using default values:

```ruby
	# Will use as target directory your current working directory (be careful!)
	EasySwig::doxygen	
	EasySwig::generate
	EasySwig::swig
```
Or with some configuration:

```ruby
	config = EasySwig::Config.new('path/to/your/directory')
	config.stl_support = nil		# Inactivate default support for the STL Library
	config.html = true				# Generates HTML documentation for your header files
	EasySwig::doxygen(config)
	EasySwig::generate(config)
	config.includes_dir = '/usr/lib/gcc/i686-linux-gnu/4.6.3/include' # Add other system include files you want SWIG to import during wrapper generation
	EasySwig::swig(config)
```

You can consult the documentation (generated with YARD: yard doc) in doc/ subfolder for more information about the EasySwig::Config class and its default values.


As CLI
----------

Download (or clone) this repository. An illustrative example of how to use EasySwig as CLI-Tool is found in subfolder Example/
Open the corresponding README file and follow the instructions. This Example project can also be used as template for your own wrappers.

```shell
cd Example
# Displays command help. Useful for parameter syntax, options and default values
sh ../bin/easyswig.sh -h
# Generate Doxygen XML Intermediate representation. Found in generated subfolder: 'easy-swig/doxygen'
sh ../bin/easyswig.sh doxygen
# Generate SWIG Interface Files (.i). Found in generated subfolder: 'easy-swig/generate'
sh ../bin/easyswig.sh generate
# Generate Wrappers using your installed version of SWIG. Found in generated subfolder: 'easy-swig/swig'
sh ../bin/easyswig.sh swig
```

Selecting which members to wrap (namespaces/classes/functions/variables...)
----------------------

EasySwig allows you to cherry-pick which members of a namespace to wrap and also offers some simple configuration. For this we make use of a CSV file
with following contents:

#namespace

target_name: Desired name of the Namespace in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ namespace. If empty, 'target_name' will be used.

wrap_classes: Every class/struct in this namespace will be wrapped.

wrap_functions: Every function outside any struct/class in this namespace will be wrapped.

wrap_enums: Every enum outside any struct/class in this namespace will be wrapped.

wrap_variables: Every variable outside any struct/class in this namespace will be wrapped.

friend_support: Support for friend members will be active by default for all structs/classes inside this namespace.

properties: Support for (C#) properties will be active by default for all structs/classes inside this namespace.

partial: Every wrapper for structs/classes inside this namespace will be generated with the 'partial' C# keyword.

nested_support: Support for Innerclasses when using SWIG 2.x (Unnecessary for versions newer than 3.0).

#function

target_name: Desired name of the function (relative to the given namespace) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ function (relative to the given namespace). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.


#variable

target_name: Desired name of the global variable (relative to the given namespace) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ global variable (relative to the given namespace). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.

#enum

target_name: Desired name of the enum (relative to the given namespace) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ enum (relative to the given namespace). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.


#class

target_name: Desired name of the class/struct (relative to the given namespace) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ class/struct (relative to the given namespace). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.

wrap_innerclasses: Every innerclass/innerstruct defined inside this class/struct will be wrapped.

wrap_methods: Every method of this class/struct will be wrapped.

wrap_enums: Every enum defined inside this class/struct will be wrapped.

wrap_attributes: Every attribute of this class/struct will be wrapped.

friend_support: Support for friend members is active.

properties: Support for generating (C#) properties will be active by default for every getter/setter method defined in this class/struct.

partial: Class will be generated with the 'partial' C# keyword.

struct: Struct will be mapped as such in the target language (only C# - not yet supported ).

nested_support: Support for Innerclasses when using SWIG 2.x (Unnecessary for versions newer than 3.0).


#method

target_name: Desired name of the method (relative to the last given class/struct) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ method (relative to the last given class/struct). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.

properties: If this method is a getter/setter, a cooresponding property will be generated in the target language (C#).

#attribute

target_name: Desired name of the attribute (relative to the last given class/struct) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ attribute (relative to the last given class/struct). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.

#innerenum

target_name: Desired name of the enum (relative to the last given class/struct) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ enum (relative to the last given class/struct). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.

#innerclass

target_name: Desired name of the innerclass (relative to the last given class/struct) in the Target Language (C#). If empty, 'basename' will be used.

basename: Name of the C/C++ innerclass (relative to the last given class/struct). If empty, 'target_name' will be used.

ignore: This member will be ignored. Useful in case it has been indirectly included by checking any of the parent's 'wrap_xxx' flags.

friend_support: Support for friend members is active.

properties: Support for generating (C#) properties will be active by default for every getter/setter method defined in this class/struct.

struct: Structs will be mapped as such in the target language (only C# - not yet supported ).

nested_support: Support for Innerclasses when using SWIG 2.x (Unnecessary for versions newer than 3.0).


