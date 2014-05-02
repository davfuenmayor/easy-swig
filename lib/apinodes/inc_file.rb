module EasySwig

  class IncFile < ApiNode

    attr_accessor :api_namespaces
    attr_accessor :ignored_namespaces
    attr_accessor :api_classes
    attr_accessor :ignored_classes
    attr_accessor :api_enums
    attr_accessor :ignored_enums
    attr_accessor :api_functions
    attr_accessor :ignored_functions
    attr_accessor :api_variables
    attr_accessor :ignored_variables
    attr_accessor :num_included
    attr_accessor :num_including
    attr_accessor :wrap_functions
    attr_accessor :wrap_variables
    attr_accessor :wrap_enums

    def initialize(hash)
      super(hash)
      @api_namespaces=[]
      @ignored_namespaces=[]
      @api_classes=[]
      @ignored_classes=[]
      @api_enums=[]
      @ignored_enums=[]
      @api_functions=[]
      @ignored_functions=[]
      @api_variables=[]
      @ignored_variables=[]
      @wrap_functions = true
      @wrap_variables = true
      @wrap_enums = true
      @added_nodes = {}
    end
    
    def <=> other
      if @num_including == 0 && other.num_including == 0 
        return(@num_included - @num_including)  <=> (other.num_included- other.num_including)
      end
      return 1 if @num_including == 0
      return -1 if other.num_including == 0
      return(@num_included - @num_including)  <=> (other.num_included- other.num_including)
    end

    def assoc_inner_node(api_node)
    	return if @added_nodes[api_node.wrapped_node]
      case api_node.node_type
        when "namespace"
          @api_namespaces << api_node
        when "function"
          @api_functions << api_node
        when "variable"
          @api_variables << api_node
        when "enum"
          @api_enums << api_node
        when "class"
          @api_classes << api_node
      end
    	@added_nodes[api_node.wrapped_node] = 1
    end
    
    def assoc_with_node(node)
      super(node)
      @num_included = files_included.size
      @num_including = files_including.size
      all_functions = node.functions
			all_enums = node.enums
			all_variables = node.variables
			
			if @wrap_functions
				all_functions.each { |f|
						hash = {'features' => @features, 'node_type' => 'function', 'parent' => self, 'basename' => f.basename }
						@api_functions << ApiFunction.new(hash).assoc_with_node(f)
				}
			end
			if @wrap_variables
				all_variables.each { |v|
						hash = {'features' => @features, 'node_type' => 'variable', 'parent' => self, 'basename' => v.basename}
						@api_variables << ApiVariable.new(hash).assoc_with_node(v)
				}
			end
			if @wrap_enums
				all_enums.each { |e|
						hash = {'features' => @features, 'node_type' => 'enum', 'parent' => self, 'basename' => e.basename }
						@api_enums << ApiEnum.new(hash).assoc_with_node(e)
				}
			end
      self
    end

    def ignore_inner_nodes
      aux = @api_namespaces.map { |n| n.wrapped_node }
      @ignored_namespaces = namespaces.select { |ns| aux.include?(ns) == false }
      aux = @api_functions.map { |n| n.wrapped_node }
      @ignored_functions = functions.select { |func| aux.include?(func) == false }
      aux = @api_variables.map { |n| n.wrapped_node }
      @ignored_variables = variables.select { |var| aux.include?(var) == false }
      aux = @api_enums.map { |n| n.wrapped_node }
      @ignored_enums = enums.select { |enum| aux.include?(enum) == false }
      aux = @api_classes.map { |n| n.wrapped_node }
      file_classes = classes + structs
      del = []
      file_classes.each { |file_cls|
        @api_classes.each { |api_cls|
          if api_cls.api_innerclasses.map { |n| n.wrapped_node }.include?(file_cls)
          del << file_cls
          end
        }
      }
      @ignored_classes = file_classes.select { |cls| !aux.include?(cls) && !del.include?(cls) }
      @ignored_classes
    end

  end
end