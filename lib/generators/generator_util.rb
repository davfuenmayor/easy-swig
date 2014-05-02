module EasySwig
  module GeneratorUtil
  	include Util
  	include Query
  	
  	def nested_workaround(innerclass)	# Innerclasses    	
      return '' if innerclass.abstract?
      return '' if no_public_constructors?(innerclass) || no_public_destructors?(innerclass)
      return '' if @all_innerclasses[innerclass.target_name]
      
      namespace = @api_class.parent
    	siblings = namespace.classes + namespace.structs
      return '' if siblings.any?{ |c| c.basename == innerclass.basename }
    	swig_file  = ''
    	own_typedefs = {}
      
      swig_file << "namespace #{namespace.name} {\n"
      swig_file << "\tclass #{innerclass.target_name} {\n"
      swig_file << "\t\tpublic:\n"
      innerclass.api_attributes.each { |attr| 
      	typename = attr.type.name
      	if is_template?(typename)
      		typename = typename.gsub('>::type', '>') # TODO only for Ogre
      	end
       	swig_file << "\t\t#{attr.static.to_s} #{typename} #{attr.basename};\n"
      }
      innerclass.api_methods.each { |meth|
      	broken = false
	      type_typename = meth.type.name
      	if is_template?(type_typename)
      		type_typename = type_typename.gsub('>::type', '>') # TODO only for Ogre
      	end
        param_typenames = ""
	      n = 1
        meth.params.map{ |p|
        	typename = p.type.name
      		if is_template?(typename)
      			typename = typename.gsub('>::type', '>') # TODO only for Ogre
      		end
      		param_typenames << " #{typename} arg#{n},"
      		n += 1
        }
        next if broken
        swig_file << "\t\t#{meth.static.to_s} #{type_typename} #{meth.basename}(#{param_typenames.chop});\n"
      }
      innerclass.api_enums.each { |enum|
        swig_file << enum_snippet(enum)
      }
      @all_innerclasses[innerclass.target_name] = 1
      swig_file << "\t};\n}\n"
      swig_file << "%rename(#{innerclass.target_name}) #{innerclass.basename};\n"
      swig_file << "%nestedworkaround #{@api_class.name}::#{innerclass.basename};\n"
      swig_file << "%{\nnamespace #{namespace.name} {\n"
      swig_file << "\ttypedef #{@api_class.name}::#{innerclass.basename} #{innerclass.target_name};\n"
      swig_file << "}\n%}\n"
      swig_file
    end
    
    def process_type(type, klass)
    	new_type = type.dup
    	new_type.name = type.escaped_name
    	new_typename = _process_type(new_type, klass)
    	type.name = type.name.gsub(type.escaped_name, new_typename)
    end
    
    def _process_type(type, klass)
    	raise ArgumentError if type.nil?
    	cached_type = @types[type.escaped_name]
    	return cached_type unless cached_type.nil?
    	# Don't instantiate templates for functions with type params
    	return nil if is_template_param?(type.escaped_name, klass)
    	
    	typename = type.escaped_name.dup
    	if is_template?(typename)
    	 	nested_typenames_for(typename).each{ |t|
    	 		nested_type = Doxyparser::Type.new({ name: t, dir: ""})
        	typename.gsub!(t, _process_type(nested_type, klass))
      	}
      	expanded_typename = typename 
      else
      	lookedup = lookup_typename(type, klass)  
      	raise ArgumentError if lookedup.nil?  	
      	if is_template?(lookedup) # Repeat recursively
      		lookedup_escaped = escape_const_ref_ptr(lookedup)
      		lookedup_type = Doxyparser::Type.new({ name: lookedup_escaped, dir: ""})
      		expanded_typename = lookedup.gsub!(lookedup_escaped, _process_type(lookedup_type, klass))
      	else
      		expanded_typename = lookedup
      	end
    	end
    	escaped_typename = escape_const_ref_ptr(expanded_typename)
    	unless @all_types.has_key?(escaped_typename)
    	  @all_types[escaped_typename] = 1
        @types[type.name] = escaped_typename
      end
			return expanded_typename	
    end
    
    def template_snippet(typename, expanded)
    	swig_file = ''
  	  expanded = expanded.gsub('>::type', '>') # TODO only for Ogre
    	if is_template?(expanded)
    		typename = name_for_template(expanded) if is_template?(typename) # TODO reconsider
      	swig_file << "%template(#{typename}) #{expanded};\n"
      end
      swig_file
    end
    
    def enum_snippet(enum)
      snippet = "\n\t\tenum #{enum.basename} {"
      aux = ''
      enum.values.each { |v|
        aux << "\n\t\t\t#{v.basename}" 
        if v.initializer
        	aux << " = #{v.initializer}," 
        else
        	aux << ","
        end
      }
      aux.chomp! ','
      snippet << aux
      snippet << "\n\t\t};\n"
      snippet
    end
    
    def ignore_enum_values_snippet(enum)
      snippet = ""
      enum.values.each { |v|
        snippet << "%rename($ignore) #{enum.parent.name}::#{v.basename};\n"
      }
      snippet
    end

  end
end