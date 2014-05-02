#!/usr/bin rspec
require 'rspec'
require_relative '../../lib/easy-swig'
require_relative '../functional_tests_support'

	
def name
	'namespacePrefixes'
end

describe "NamespacePrefixes" do
	
	before(:all) do
		@spec_dir = File.dirname(__FILE__)
		@config = EasySwig::Config.new(@spec_dir)
		@config.stl_support = nil
		@swig_dir = ::File.expand_path('./easy-swig/swig', @spec_dir)
		
		EasySwig::doxygen(@config)
		EasySwig::generate(@config)
		EasySwig::swig(@config)
	end

	it "should run swig succesfully" do
		::File.exists?(@swig_dir).should be_true
		::File.exists?(@swig_dir+"/#{name}_wrap.cxx").should be_true
		::File.exists?("#{@swig_dir}/#{name}/VectorInt.cs").should be_true
		::File.exists?("#{@swig_dir}/#{name}/VectorKlass1.cs").should be_true
		::File.exists?("#{@swig_dir}/#{name}/VectorKlass2.cs").should be_true	
	end
	
	it "should compile C# code" do
		verify_compilation_csharp(@swig_dir, name) # .dll
	end
	
	it "should compile C++ wrapper" do
		verify_compilation_cpp(@swig_dir, name) # .o  
	end
end
