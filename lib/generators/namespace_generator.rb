module EasySwig

  class NamespaceGenerator
    include GeneratorUtil

    def initialize(api_ns)
      @api_ns = api_ns
    end

    def generate
      swig_file = generate_functions
      swig_file << generate_variables
      swig_file << generate_enums
    end

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
        swig_file << %Q{%rename(#{m.target_name}) #{m.name};} + "\n"
      }
      swig_file
    end

    def generate_enums
      swig_file = ''
      @api_ns.ignored_enums.each { |m|
        swig_file << %Q{%rename("$ignore") #{m.name};} + "\n"
      }
      @api_ns.api_enums.each { |enum|
        if anonymous_enum?(enum)  # @Anonymous Enums
          swig_file << "\nnamespace #{@api_ns.name} {\n"
          swig_file << enum_snippet(enum)
          swig_file << "\n}\n"
	        swig_file << ignore_enum_values_snippet(enum)
        else
          swig_file << %Q{%rename(#{enum.target_name}) #{enum.name};} + "\n"
        end
      }
      swig_file
    end
  end
end