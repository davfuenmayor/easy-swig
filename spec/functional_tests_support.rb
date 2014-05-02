require 'fileutils'

def verify_compilation_csharp(dir, basename)
	command = "mcs -unsafe -out:#{basename}.dll -recurse:'#{basename}/*.cs' -target:library"
	execute_commands(dir, command).should be_true 
	File.exists?("#{dir}/#{basename}.dll").should be_true 
end

def verify_compilation_cpp(dir, basename)
	command = "g++ -fPIC -g -Wall -c -o #{basename}.o -I../../include *.cxx"
	execute_commands(dir, command).should be_true 
	File.exists?("#{dir}/#{basename}.o").should be_true 
end

def verify_linking_cpp(dir, basename, shared_lib=nil)
	shared_lib ||= 'lib*.a'
	soname = "lib#{basename}.so"
	basedir = File.expand_path('../../', dir)
	FileUtils.cp_r Dir.glob(basedir + '/lib/lib*.*'), dir, preserve: true
	link = "g++ -shared -g -z defs -Wl,-rpath=.,-soname=#{soname} -o #{soname}.1 *.o -lc -L. -l#{shared_lib}"
	ldconfig = "ldconfig -n ."
	execute_commands(dir, link, ldconfig).should be_true 
	File.exists?("#{dir}/#{soname}").should be_true 
end

def verify_functional_test(dir, basename)
	base = File.expand_path('../../', dir)
	FileUtils.cp_r Dir.glob(base + '/csharp/*.cs'), dir	
	compile = "mcs -unsafe -out:#{basename}.exe -recurse:'*.cs'"
	run = "mono #{basename}.exe > exec_output 2>&1"
	execute_commands(dir, compile, run).should be_true 	
end

def compile_lib(inc_dir, lib_dir, basename)
	soname = "lib#{basename}.so"
	compile = "g++ -fPIC -g -c -Wall -o #{basename}.o #{inc_dir}/*.cxx"
	link = "g++ -shared -Wl,-rpath=#{lib_dir},-soname=#{soname} -o #{soname} *.o -lc"
	ldconfig = "ldconfig -n ."
	execute_commands(lib_dir, compile, link, ldconfig).should be_true 
end

def execute_commands(dir, *commands)
	pwd = Dir.pwd
	Dir.chdir dir
	commands.each { |command| 
		output = IO.popen(command)
  	puts "Output for command: #{command}\n" + output.readlines.join	
  	output.close
		return false if $?!= 0
	}	
  Dir.chdir pwd
  return true
end