EasySwig
=========

Automatically generates wrappers for C/C++ code using SWIG.

This is both a Ruby Gem and a CLI Tool. Feed it with a directory containing the library's header files (the ones you want to wrap) and a CSV File with basic configuration (see usage). EasySwig will generate the corresponding SWIG interface files (.i) in an output directory. EasySwig also offers a facade allowing you to directly call SWIG in order to generate wrappers in the target language.

EasySwig supports currently only C#. There is  ongoing work on other languages support.


Installation and Use
------------

EasySwig relies on the Doxyparser gem (https://github.com/davfuenmayor/ruby-doxygen-parser) which on his part depends on Nokogiri (http://nokogiri.org) and Doxygen (www.doxygen.org). Refer to Doxyparser for more information.

To actually generate wrappers you may also want to install SWIG (http://www.swig.org/). Currently only SWIG version 2.0.11 is supported. There is  ongoing work on 3.0.0 version support.


For using EasySwig you need to create a folder with the following structure:
(it is recommended to use the subfolder 'spec/Example' as a template)

- A subfolder named 'include' with the header files you want to wrap.
- A CSV file named 'api.csv' with the name of the namespace you want to wrap and which classes to wrap/ignore.
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

You can consult the documentation (generated with YARD) in doc/ subfolder for more information about the EasySwig::Config class and its default values.


As CLI
----------

Download (or clone) this repository. An illustrative example of how to use EasySwig as CLI-Tool is found in subfolder spec/Example.
Open the corresponding README file and follow the instructions. This Example project can also be used as template for your own wrappers.

```shell
cd spec/Example
# Displays command help. Useful for parameter syntax, options and default values
sh ../../bin/easyswig.sh -h
# Generate Doxygen XML Intermediate representation. Found in generated subfolder: 'easy-swig/doxygen'
sh ../../bin/easyswig.sh doxygen
# Generate SWIG Interface Files (.i). Found in generated subfolder: 'easy-swig/generate'
sh ../../bin/easyswig.sh generate
# Generate Wrappers using your installed version of SWIG. Found in generated subfolder: 'easy-swig/swig'
sh ../../bin/easyswig.sh swig
```


