module EasySwig
  module Query
  	
  	def get_reference_type(type, klass)
  		if is_primitive?(type.name)
    		return :ptr
    	elsif type.name.end_with?('&')
    		return :ref
    	elsif type.name == 'std::string'
    		return :str
    	else
    		looked_up = klass.lookup_node(type)
    		return nil if looked_up.nil?
    		if type.name.end_with?('*')
    			if is_primitive?(looked_up.name)
    				return :prim_ptr
    			end
    			return :ptr
    		end
    		if looked_up.class == Doxyparser::Enum
    			return :ptr
    		else
    			return :val
    		end
    	end  
    end

    def lookup_typename(type, klass) # Type should not have * & const
    	escaped_typename = escape_template(type.escaped_name)
      return type.escaped_name if escaped_typename.include?('::') || is_primitive?(escaped_typename)
      return type.escaped_name.gsub(escaped_typename, 'std::' + escaped_typename) if is_std?(escaped_typename)      
      lookedup = klass.lookup_node(type)
      return nil if lookedup.nil?
			lookedup.name
    end 
    
    def nested_typenames_for(typename) 
    	Doxyparser::Type.nested_typenames(typename)
    end
    
    def no_public_constructors?(klass)
    	klass.constructors(:public).empty? && !klass.constructors(:all).empty?
    end
    
    def no_public_destructors?(klass)
    	klass.destructors(:public).empty? && !klass.destructors(:all).empty?
    end
  	
  	def name_for_template(template_name)
    		nested_typenames_for(template_name).map{ |typename|
    			 del_prefix_class(typename.split(' ').join('')).capitalize 
    		}.join('')
    end

    def name_for_operator(typename, num_args)
      ret = case typename
        when 'operator+'
          return num_args == 2 ? '__add__' : '__pos__'
        when 'operator-'
          return num_args == 2 ? '__sub__' : '__neg__'
        when 'operator*'
          return '__mul__'
        when 'operator/'
          return '__div__'
        when 'operator%'
          return '__mod__'
        when 'operator<<'
          return '__lshift__'
        when 'operator>>'
          return '__rshift__'
        when 'operator&'
          return '__and__'
        when 'operator||'
          return '__or__'
        when 'operator^'
          return '__xor__'
        when 'operator~'
          return '__invert__'
        when 'operator<'
          return '__lt__'
        when 'operator<='
          return '__le__'
        when 'operator>'
          return '__gt__'
        when 'operator>='
          return '__ge__'
        when 'operator=='
          return '__eq__'
        when 'operator()'
          return '__call__'
      else
      return nil
      end
    end

    def name_for_friend(typename, num_args = 0)
      return '_friend_' + typename if num_args == 0
      result = name_for_operator(typename, num_args)
      return result.nil? ? '_friend_' + typename : result
    end
    
    def is_template_param?(typename, klass)
    	class_template_params = klass.template_params.map{|tp| tp.declname}
    	return if nested_typenames_for(typename).any?{ |t| 
    		class_template_params.include?(t) 
    	}
    end
    
    def is_template?(typename)
    	Doxyparser::Type.template?(typename)
    end
    
    def is_operator?(name)
    	name =~ /operator\W+/
    end

    def method_has_blacklisted_types?(method)
      return true if type_is_blacklisted?(method)
      return true if method.params.any?{ |p| type_is_blacklisted?(p) }
      return false
    end

    def type_is_blacklisted?(p)
      return p.type.nested_typenames.any?{ |t| typename_is_blacklisted?(t)}
    end

    def typename_is_blacklisted?(typename)
      return typename == 'multimap' || typename == 'std::multimap'
    end
    
    def anonymous_enum?(enum)
      enum.basename =~ /_Enum\d*$/
    end

  end
end