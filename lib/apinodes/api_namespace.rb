module EasySwig

	class ApiNamespace < ApiNode

		attr_accessor :api_classes
		attr_accessor :api_variables
		attr_accessor :api_functions
		attr_accessor :api_enums
		attr_accessor :ignored_functions
		attr_accessor :ignored_variables
		attr_accessor :ignored_classes
		attr_accessor :ignored_enums
		attr_accessor :wrap_classes
		attr_accessor :wrap_functions
		attr_accessor :wrap_enums
		attr_accessor :wrap_variables
		attr_accessor :nested_support
		attr_accessor :friend_support

		def initialize(hash)
			super(hash)
			@api_classes=[]
			@api_variables=[]
			@api_functions=[]
			@api_enums=[]
			@ignored_functions=[]
			@ignored_variables=[]
			@ignored_classes=[]
			@ignored_enums=[]
		end

		def api_nodes
			return [self] if @api_classes.empty? # Only if there are no classes in this namespace
			@api_classes
		end

		def assoc_with_node(ns)
			super(ns)
			all_functions = ns.functions
			all_functions.reject!{ |f| f.basename == f.basename.upcase }
			all_classes = ns.classes + ns.structs
			all_enums = ns.enums
			all_variables = ns.variables
			ign_functions = @ignored_functions.map{|i| i.basename}
			ign_classes = @ignored_classes.map{|i| i.basename}
			ign_enums = @ignored_enums.map{|i| i.basename}
			ign_variables = @ignored_variables.map{|i| i.basename}

			if @wrap_functions
				all_functions.each { |f|
					if not ign_functions.include?(f.basename)
						hash = {'features' => @features, 'node_type' => 'function', 'parent' => self, 'basename' => f.basename }
						@api_functions << ApiFunction.new(hash).assoc_with_node(f)
					end
				}
			else
				assoc_functions(all_functions, @api_functions, @ignored_functions)
			end

			if @wrap_classes
				all_classes.each { |c|
					if not ign_classes.include?(c.basename)
						hash = {'wrap_methods' => 'x',
							'wrap_attributes' => 'x',
							'wrap_enums' => 'x',
							'wrap_innerclasses' => 'x',
							'node_type' => 'class',
							'nested_support' => @nested_support,
							'friend_support' => @friend_support,
							'features' => @features,
							'parent' => self,
							'basename' => c.basename }
						@api_classes << ApiClass.new(hash).assoc_with_node(c)
					end
				}
			else
				assoc_members(all_classes, @api_classes, @ignored_classes)
			end
			
			if @wrap_variables
				all_variables.each { |v|
					if not ign_variables.include?(v.basename)
						hash = {'features' => @features, 'node_type' => 'variable', 'parent' => self, 'basename' => v.basename}
						@api_variables << ApiVariable.new(hash).assoc_with_node(v)
					end
				}
			else
				assoc_members(all_variables, @api_variables, @ignored_variables)
			end
			if @wrap_enums
				all_enums.each { |e|
					if not ign_enums.include?(e.basename)
						hash = {'features' => @features, 'node_type' => 'enum', 'parent' => self, 'basename' => e.basename }
						@api_enums << ApiEnum.new(hash).assoc_with_node(e)
					end
				}
			else
				assoc_members(all_enums, @api_enums, @ignored_enums)
			end
			self
		end

	end
end