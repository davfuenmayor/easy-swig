module EasySwig

  class CSharpNamespaceGenerator < NamespaceGenerator
  
  protected
		
		def generate_functions
			swig_file = ''
			@api_ns.ignored_functions.each { |m|
				swig_file << %Q{%rename("$ignore") #{m.name};} + "\n"
			}
			@api_ns.api_functions.each { |m|
				swig_file << %Q{%rename(#{m.target_name}) #{m.name};} + "\n"
			}
			swig_file
		end
		
		def generate_variables
			swig_file = ''
			@api_ns.ignored_variables.each { |m|
				swig_file << %Q{%rename("$ignore") #{m.name};} + "\n"
			}
			@api_ns.api_variables.each { |m|
				if type_is_blacklisted?(m)
					swig_file << %Q{%rename("$ignore") #{m.name};} + "\n"
				else
					swig_file << %Q{%rename(#{m.target_name}) #{m.name};} + "\n"
				end
			}
			swig_file
		end
  end
 end
