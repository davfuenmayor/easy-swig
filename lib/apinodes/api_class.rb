module EasySwig

  class ApiClass < ApiNode

    attr_accessor :api_methods
    attr_accessor :api_attributes
    attr_accessor :api_innerclasses
    attr_accessor :api_enums
    attr_accessor :ignored_methods
    attr_accessor :ignored_attributes
    attr_accessor :ignored_innerclasses
    attr_accessor :ignored_enums
    attr_accessor :match_subclasses
    attr_accessor :match_superclasses
    attr_accessor :group
    attr_accessor :wrap_innerclasses
    attr_accessor :wrap_methods
    attr_accessor :wrap_enums
    attr_accessor :wrap_attributes
    attr_accessor :nested_support
    attr_accessor :friend_support

    def initialize(hash)
      super(hash)
      @lookup_cache = {}
      @api_methods=[]
      @api_attributes=[]
      @api_innerclasses=[]
      @api_enums=[]
      @ignored_methods=[]
      @ignored_attributes=[]
      @ignored_innerclasses=[]
      @ignored_enums=[]
      @director=false
    end

    def api_nodes
      [self]
    end
    
    def file
      return wrapped_node.file if node_type != 'innerclass'
      return parent.file
    end

    def assoc_with_node(clazz)
      super(clazz)
      assoc_methods
      assoc_attributes
      assoc_innerclasses
      assoc_enums
    end

    def assoc_methods
    	all_methods = @wrapped_node.methods + @wrapped_node.methods('public', 'static', nil)
    	all_methods.reject!{ |f| f.basename == f.basename.upcase }
    	ign_methods = @ignored_methods.map{|i| i.basename}
      if @wrap_methods
        all_methods.each { |m|
          if not ign_methods.include?(m.basename)
            hash = {'features' => @features, 'node_type' => 'method', 'parent' => self, 'basename' => m.basename }
            @api_methods << ApiMethod.new(hash).assoc_with_node(m)
          end
        }
      else
        assoc_functions(all_methods, @api_methods, @ignored_methods)
      end
    end

    def assoc_attributes
    	all_attributes = @wrapped_node.attributes + @wrapped_node.attributes('public', 'static')
      ign_attributes = @ignored_attributes.map{|i| i.basename}
      if @wrap_attributes
        all_attributes.each { |a|
          if not ign_attributes.include?(a.basename)
            hash = {'features' => @features, 'node_type' => 'attribute', 'parent' => self, 'basename' => a.basename }
            @api_attributes << ApiAttribute.new(hash).assoc_with_node(a)
          end
        }
      else
        assoc_members(all_attributes, @api_attributes, @ignored_attributes)
      end
    end

    def assoc_innerclasses
    	all_innerclasses = @wrapped_node.innerclasses
      ign_innerclasses = @ignored_innerclasses.map{|i| i.basename}
      if @wrap_innerclasses
        all_innerclasses.each { |c|
          if !ign_innerclasses.include?(c.basename)
            hash = {'wrap_methods' => 'x',
              'wrap_attributes' => 'x',
              'wrap_enums' => 'x',
              'wrap_innerclasses' => 'x',
              'node_type' => 'innerclass',
              'nested_support' => @nested_support,
              'features' => @features,
              'parent' => self,
              'basename' => c.basename }
            @api_innerclasses << ApiClass.new(hash).assoc_with_node(c)
          end
        }
      else
        assoc_members(all_innerclasses, @api_innerclasses, @ignored_innerclasses)
      end
    end

    def assoc_enums
    	all_enums = @wrapped_node.enums
      ign_enums = @ignored_enums.map{ |i| i.basename }
      if @wrap_enums
        all_enums.each { |e|
          if !ign_enums.include?(e.basename)
            hash = {'features' => @features, 'node_type' => 'enum', 'parent' => self, 'basename' => e.basename }
            @api_enums << ApiEnum.new(hash).assoc_with_node(e)
          end
        }
      else
        assoc_members(all_enums, @api_enums, @ignored_enums)
      end
      self
    end
    
    def lookup_node(type)
    	cached = @lookup_cache[type.escaped_name]
    	return cached if cached
    	looked_up = _lookup_node(type)
    	@lookup_cache[type.escaped_name] = looked_up
			looked_up
    end
    
    def _lookup_node(type) # TODO use lookup methods of Doxyparser and avoid selects
    	return Doxyparser::Type.new({ name: type.basename, dir: ""}) if is_primitive?(type.basename) 
    	return type if is_std?(type.basename)
    	return @wrapped_node if type.basename == @basename
    	expanded_type = expand_typedefs(type)
    	if expanded_type != type
    		looked_up_type = lookup_node(expanded_type)
    		return expanded_type if looked_up_type.nil? # TODO why?
    		looked_up = expanded_type.name.gsub(expanded_type.escaped_name, looked_up_type.escaped_name)
   			return Doxyparser::Type.new({ name: looked_up, dir: ""})
   		end
    	innerclass = innerclasses.select { |ic| ic.basename == type.basename }
    	unless innerclass.empty?
    		if type.template?
    			new_name = type.escaped_name.gsub(type.basename, innerclass[0].name)
	    		return Doxyparser::Type.new({ name: new_name, dir: innerclass[0].dir})
    		end
    		return innerclass[0]
    	end
    	enum = enums.select { |ie| ie.basename == type.basename }
    	return enum[0] unless enum.empty?
    	if node_type == 'innerclass'
    		sibling = parent.innerclasses.select { |c| c.basename == type.basename }
    	else
    		siblings = parent.classes + parent.structs
    		sibling = siblings.select { |c| c.basename == type.basename }
    	end
    	unless sibling.empty?
    		if type.template?
    			new_name = type.escaped_name.gsub(type.basename, sibling[0].name)
	    		return Doxyparser::Type.new({ name: new_name, dir: sibling[0].dir})
    		end
    		return sibling[0] 
    	end
    	parent_enum = parent.enums.select { |e| e.basename == type.basename }
    	return parent_enum[0] unless parent_enum.empty?
    	if node_type == 'innerclass'
    		return parent.lookup_node(type)
    	else
      	puts "Type '" + type.basename+ "' not found in class '" + @wrapped_node.name + "'\n-> Function or variable will be ignored."
      	return nil
    	end
    end
    
    def expand_typedefs(type)
    	typedef = visible_typedefs.select { |t| t.basename == type.basename } # TODO use Doxyparser, avoid selects
    	return type if typedef.empty?
    	new_type = typedef[0].type.dup
    	new_type.name = type.name.gsub(type.escaped_name, new_type.name)
    	expand_typedefs(new_type)
    end

    def visible_typedefs
    	if node_type == 'innerclass'
    		return typedefs(:all) 
    	end    		
      namespace = @parent
      files_included = file.files_included
      ns_typedefs = [] if namespace.nil?
      ns_typedefs ||= namespace.typedefs.select { |typedef|
        included_in_files(typedef, [file, *files_included])
      }
      typedefs(:all) + file.typedefs + ns_typedefs
    end

    def included_in_files(typedef, files) ## TODO Optimize this
      files.any? { |file|
        ::File.basename(typedef.location) =~ %r{#{file.basename}:\d+$}
      }
    end
    
    def is_enum_or_innerclass?(target_name)    	
    	(innerclasses + enums).any?{ |c| c.basename == target_name}
    end
  end
end