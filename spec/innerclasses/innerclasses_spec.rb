#!/usr/bin rspec
require 'rspec'
require_relative '../../lib/easy-swig'
require_relative '../functional_tests_support'

def name
	'innerclasses'
end

describe "Innerclasses" do
	
	before(:all) do
		@spec_dir = File.dirname(__FILE__)
		@config = EasySwig::Config.new(@spec_dir)
		@config.stl_support = nil
		@swig_dir = ::File.expand_path('./easy-swig/swig', @spec_dir)
		
		EasySwig::doxygen(@config)
		# Uncomment to regenerate files when needed
		#compile_lib(@spec_dir + '/include', @spec_dir + '/lib', name.capitalize + 'Spec' )
		EasySwig::generate(@config)
		EasySwig::swig(@config)
	end
	
	it "should run swig succesfully" do
		::File.exists?(@swig_dir).should be_true
		::File.exists?(@swig_dir+"/#{name}_wrap.cxx").should be_true
		::File.exists?(@swig_dir+"/#{name}/Inner3.cs").should be_false
		::File.exists?(@swig_dir+"/#{name}/Inner4.cs").should be_false
		::File.exists?(@swig_dir+"/#{name}/Inner5.cs").should be_false
	end
	
	it "should compile C# code" do
		verify_compilation_csharp(@swig_dir, name) # .dll
	end
	
	it "should compile C++ wrapper" do
		verify_compilation_cpp(@swig_dir, name) # .o  
	end
	
	it "should link C++ wrapper against shared library" do
		verify_linking_cpp(@swig_dir, name, name.capitalize + 'Spec')  # lib#{name}.so
	end
	
	it "should run functional tests" do
		verify_functional_test(@swig_dir, name.capitalize + 'Test') # .cs
	end
end
