module EasySwig
	class HFileGenerator
		include GeneratorUtil

		def initialize(hfile)
  		@hfile = hfile
  	end

		def generate
			swig_file = generate_functions
			swig_file << generate_variables
			swig_file << generate_enums
			swig_file << generate_classes
		end
		
		def generate_functions
			swig_file = ''
			@hfile.ignored_functions.each { |func|
        swig_file << %Q{%rename("$ignore") #{func.basename};} + "\n"
      }
			swig_file
		end
		
		def generate_variables
			swig_file = ''
			@hfile.ignored_variables.each { |var|
        swig_file << %Q{%rename("$ignore") #{var.basename};} + "\n"
      }
			swig_file
		end
		
		def generate_enums
			swig_file = ''
			@hfile.api_enums.each { |enum|
      	if anonymous_enum?(enum)  # @Anonymous Enums
          swig_file << enum_snippet(enum)
					enum.values.each { |v|
    	    	swig_file << "%rename($ignore) ::#{v.basename};\n"
	     		}
				end
      }
			@hfile.ignored_enums.each { |enum|
        swig_file << %Q{%rename("$ignore") #{enum.basename};} + "\n"
      }
			swig_file
		end
		
		def generate_classes
			swig_file = ''
			@hfile.ignored_classes.each { |cls|
        swig_file << %Q{%rename("$ignore") #{cls.name};} + "\n"
      }
			swig_file
		end
	end
end
