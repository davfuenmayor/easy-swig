module EasySwig
  module Csharp

    class CsharpFeatures < EasySwig::Features

      attr_accessor :properties
      attr_accessor :struct
      attr_accessor :director
      attr_accessor :immutable
      attr_accessor :partial

      def to_s
        s = @properties ? 'properties': ''
        s << @struct ? 'struct' : ''
        s << @director ? 'director' : ''
        s << @immutable ? 'immutable' : ''
      end

      def to_str
        to_s
      end

      def infer_basename(node)
        aux = node.target_name.gsub(/_([a-z])/i) { |match|
          $1.upcase
        }
        case node.node_type
          when 'function', 'attribute', 'variable'
            node.basename = aux.gsub(/^([A-Z])/) { |match|
              $1.downcase
            }
          when 'method'
            if node.constructor?
            node.basename =  aux
            else
              node.basename = aux.gsub(/^([A-Z])/) { |match|
                $1.downcase
              }
            end
          when 'class', 'enum'
            node.basename = aux.gsub(/^([a-z])/) { |match|
              $1.upcase
            }
          when 'namespace'
            node.basename = node.target_name.gsub(".", "::")
        else
        super node
        end

      end

      def ignore_operator(name)
        ['operator+','operator+=', 'operator-',
          'operator-=', 'operator*', 'operator*=',
          'operator/', 'operator/=', 'operator<',
          'operator<=', 'operator>', 'operator>=',
          'operator=', 'operator[]', 'operator==',
          'operator!=', 'operator^', 'operator~',
          'operator%', 'operator&', 'operator|',
          'operator&&', 'operator||', 'operator<<',
          'operator>>'].include?(name)
      end

      def infer_target_name(node)
        case node.node_type
          when 'method'
            if node.basename.start_with? '~'
              node.target_name = 'Dispose'
            	return
            end
            if @properties
              node.target_name ||= node.setter_for
              node.target_name ||= node.getter_for
              if node.target_name
              	list = []
              	wnode = node.parent.wrapped_node
								list.push(*wnode.methods)
								list.push(*wnode.attributes)             	
              	if list.any? { |m| m.basename.capitalize == node.target_name.capitalize }
                	node.target_name.prepend('_')
                end
              end
            end
            node.target_name ||= node.basename
            node.target_name = node.target_name.gsub(/^(_?)([a-z])/) { |match|
              $2.upcase.prepend $1
            }
          when 'function', 'variable', 'attribute'
            node.target_name ||= node.basename.gsub(/^([a-z])/) { |match|
              $1.upcase
            }
          when 'namespace'
            node.target_name ||= node.basename.gsub("::", ".")
        else
        super node
        end
      end
    end
  end
end