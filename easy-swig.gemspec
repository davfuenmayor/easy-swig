# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'easy-swig'
  s.version     = '1.1'
  s.platform    = Gem::Platform::RUBY
  s.date        = '2014-05-10'
  s.summary     = "Library and CLI-Tool for automatic generation wrappers for C/C++ code using SWIG"  
  s.authors     = ["David Fuenmayor"]
  s.email       = ["davfuenmayor@gmail.com"]
  s.description = <<-END
  
Library and CLI-Tool for automatic generation wrappers for C/C++ code using SWIG.
This is both a Ruby Gem and a CLI Tool. Feed it with a directory containing the library's header files (the ones you want to wrap) and a CSV File with basic configuration (see usage). EasySwig will generate the corresponding SWIG interface files (.i) in an output directory. EasySwig also offers a facade allowing you to directly call SWIG in order to generate wrappers in the target language.

EasySwig relies on the Doxyparser gem (https://github.com/davfuenmayor/ruby-doxygen-parser) which on his part depends on Nokogiri (http://nokogiri.org) and Doxygen (www.doxygen.org). Refer to Doxyparser for more information.
For using EasySwig you may also want to install SWIG (http://www.swig.org/). SWIG versions 2.x and 3.x are supported.

EasySwig supports currently only C#. There is  ongoing work on other languages support.

END
  
  patterns = [
    'README.md',
    'MIT_LICENSE',
    'lib/**/*.rb',
  ]
  s.files = patterns.map {|p| Dir.glob(p) }.flatten
  s.homepage    =    'http://github.com/davfuenmayor/easy-swig'
    
  s.test_files = Dir.glob('spec/**/*_spec.rb')

  s.require_paths = ['lib']
  s.license = 'MIT'
end
