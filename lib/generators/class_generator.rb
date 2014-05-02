module EasySwig

  class ClassGenerator
  	include GeneratorUtil

    def initialize(api_cls, all_types, all_innerclasses, all_friends)
      @api_class = api_cls
      @all_types = all_types
    	@all_innerclasses = all_innerclasses
    	@all_friends = all_friends
    	@types = {}
    end
    
    def process_types
    	swig_file = ''
    	swig_file << process_types_for(@api_class)
    	@api_class.api_innerclasses.each { |c|
    		swig_file << process_types_for(c)
    	}
    	swig_file
    end
    
    def process_types_for(klass)
    	swig_file = ''
      klass.parent_types(:all).each { |p_type|
      	begin
      		process_type(p_type, klass)
      	rescue ArgumentError;	end 
      }
      remove_methods = []
    	klass.api_methods.each { |m|
    		begin
		      process_type(m.type, klass) unless m.constructor? || m.destructor? 
		      m.params.each { |p|
		      	process_type(p.type, klass)
		      }
        rescue ArgumentError
        	remove_methods << m
      		swig_file << %Q{%rename("$ignore") #{klass.name}::#{m.basename};} + "\n"
      	end
      }
      klass.api_methods.reject! { |m| remove_methods.include?(m) }
      
      remove_attributes = []
      klass.api_attributes.each { |a|
      	begin 
      		process_type(a.type, klass)
      	rescue ArgumentError
      		remove_attributes << a
      		swig_file << %Q{%rename("$ignore") #{klass.name}::#{a.basename};} + "\n"
      	end
      }
      klass.api_attributes.reject! { |a| remove_attributes.include?(a) }
      swig_file
    end

    def gen_methods
      swig_file = ''      
      @api_class.ignored_methods.each { |m|
        swig_file << %Q{%rename("$ignore") #{@api_class.name}::#{m.basename};} + "\n"
      }
      properties = {}
      @api_class.api_methods.each { |m| 
      	if m.basename=='getTextureAddressingMode'
      		puts "Aqui"
      	end
        features = m.features
        if features.properties
          getter = m.getter_for
          setter = m.setter_for
          if setter
            properties[m.target_name] ||= EasySwig::Properties.new
            properties[m.target_name].setter = m.basename
            properties[m.target_name].static = m.static
          	properties[m.target_name].type_setter ||= m.params[0].type
          elsif getter
            properties[m.target_name] ||= EasySwig::Properties.new
          	properties[m.target_name].getter = m.basename
          	properties[m.target_name].static = m.static
          	properties[m.target_name].type_getter = m.type
          else
            swig_file << %Q{%rename(#{m.target_name}) #{m.name};\n} unless is_operator?(m.basename) || @api_class.is_enum_or_innerclass?(m.target_name)
          	next
          end
        properties[m.target_name].class_name = @api_class.name
        else
          swig_file << %Q{%rename(#{m.target_name}) #{m.name};\n} unless is_operator?(m.basename) || @api_class.is_enum_or_innerclass?(m.target_name)
        end
      }
      properties.each { |attribute, property|
      	next if property.getter.nil? 
      	next if property.type_setter != property.type_getter
      	type = property.type_getter
    		case get_reference_type(type, @api_class)
				when :ptr
					macro = 'attribute'
					escaped_typename = type.escaped_name.gsub('>::type', '>') # TODO only for Ogre
				when :ref
					macro = 'attribute2'
					next # Ref Properties not supported
				when :str
					macro = 'attributestring'
					escaped_typename = type.escaped_name
				when :prim_ptr
					macro = 'attribute'
					escaped_typename = type.name
				when :val
					macro = 'attributeval'
					next # Properties per Value not supported
				end
				unless macro.nil?
					macro << '_static' if property.static
      		swig_file << "%#{macro}(#{property.class_name}, #{escaped_typename}, #{attribute}, #{property.getter}, #{property.setter});\n"
      	end
      }
      swig_file
    end

    def gen_attributes
      swig_file = ''
      @api_class.ignored_attributes.each { |m|
        swig_file << %Q{%rename("$ignore") #{m.name};} + "\n"
      }
      @api_class.api_attributes.each { |a|
        swig_file << %Q{%rename(#{a.target_name}) #{a.name};} + "\n"
      }
      swig_file
    end

    def gen_enums
      swig_file = ''
      @api_class.ignored_enums.each { |m|
        swig_file << %Q{%rename("$ignore") #{m.name};} + "\n"
      }
      @api_class.api_enums.each { |enum|
      	if anonymous_enum?(enum)  # @Anonymous Enums
          swig_file << "\nnamespace #{@api_class.parent.name} {"
          swig_file << enum_snippet(enum)
        	swig_file << "\t}\n"
					swig_file << ignore_enum_values_snippet(enum)
        else
        swig_file << %Q{%rename(#{enum.target_name}) #{enum.name};} + "\n"
				end
      }
      swig_file
    end

    def gen_innerclasses
      swig_file = ''
      @api_class.ignored_innerclasses.each { |c|
        swig_file << %Q{%rename("$ignore") #{@api_class.name}::#{c.basename};} + "\n"
      }
      @api_class.api_innerclasses.each { |c|
        if c.nested_support							# Innerclasses
          swig_file << nested_workaround(c)
        else
          swig_file << %Q{%rename(#{c.target_name}) #{@api_class.name}::#{c.basename};\n}
        end
      }
      swig_file
    end
      
    def gen_parent_templates
    	swig_file = "\n"
      @types.invert.each { |expanded, typename|
      	swig_file << template_snippet(typename, expanded)
      }
      swig_file
    end
    
    def gen_type_templates
      swig_file = "\n"     
      @types.invert.each { |expanded, typename|
      	swig_file << template_snippet(typename, expanded)
      }
      swig_file
    end

    def gen_friends
      swig_file = ''
      if @api_class.friend_support
        namespace = @api_class.parent
        friend_functions = @api_class.friends.delete_if{ |f| f.is_class? || f.is_qualified? }
        return '' if friend_functions.empty?
        
        swig_file << "namespace #{namespace.name} {\n"
        swig_file << "\tclass #{@api_class.basename};\n"
        friend_functions.each { |f|
        	next if @all_friends[f.basename + f.args]
          swig_file << "\t#{f.type.name} #{name_for_friend(f.basename, f.params.size)}#{f.args};\n"
        }
        swig_file << "}\n"
        swig_file << "%{\nnamespace #{namespace.name} {\n"
        swig_file << "\tclass #{@api_class.basename};\n"
        friend_functions.each { |f|
        	signature = f.basename + f.args
        	next if @all_friends[signature]
        	@all_friends[signature] = 1
        	param_names = f.params.map { |p| p.declname }.join(', ') # TODO What happens when declname is empty
        	friend_name = name_for_friend(f.basename, f.params.size)
          swig_file << "\t#{f.type.name} #{friend_name}#{f.args}{\n"
          swig_file << "\t\treturn #{f.basename}(#{param_names});\n\t}\n"
        }
        swig_file << "}\n%}\n"
      end
      swig_file
    end
  end
end