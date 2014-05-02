module EasySwig
module Readers
  class CsvParser
    
    attr_accessor :col_headers
    attr_accessor :table

    def initialize csv_file, lang
      @lang = lang
      @csv_file=csv_file
      @col_headers = {}
      @table = []
      parse
    end

    def parse
      File.open(@csv_file) { |f|
        aux = f.readline
        var = aux.chomp.split(%r{[,\t]})
        until var[0]==nil || var[0].empty?
          @col_headers[var[0]] = var[1..-1]
          var = f.readline.chomp.split(%r{[,\t]})
        end
        until f.eof?
          row = f.readline.chomp.split(%r{[,\t]})
          row.each { |r| r.strip! }
          rowtype=row[0]
          if rowtype.nil? || rowtype.empty?
            next
          end
          row = @col_headers[rowtype].zip(row[1..-1]).flatten
          lang_features = EasySwig::Features.create_instance @lang 
          line = Hash['features', lang_features, 'node_type', rowtype, *row].delete_if { |k, v| k=="" || v.nil? || v.empty? }
          @table << line
        end
      }
    end

    # Generate namespace object representations from an input CSV file
    def namespaces_from_csv
      obj=nil
      namespaces=[]
      last_ns=nil
      last_class=nil

      @table.each { |type|
        ignore = type['ignore']
        obj=nil
        case type['node_type']
          when 'namespace'
            obj=ApiNamespace.new(type)
            last_ns=obj
            namespaces << obj
          when 'class'
            type['parent'] = last_ns
            obj=ApiClass.new(type)
            last_class=obj            
            if ignore
              last_ns.ignored_classes << obj
            else
              last_ns.api_classes << obj
            end
          when 'enum'
            type['parent'] = last_ns
            obj=ApiEnum.new(type)
            if ignore
              last_ns.ignored_enums << obj
            else
              last_ns.api_enums << obj
            end            
          when 'function'
            type['parent'] = last_ns
            obj=ApiFunction.new(type)
            if ignore
              last_ns.ignored_functions << obj
            else
              last_ns.api_functions << obj
            end
          when 'variable'
            type['parent'] = last_ns
            obj=ApiVariable.new(type)
            if ignore
              last_ns.ignored_variables << obj
            else
              last_ns.api_variables << obj
            end
          when 'method'
            type['parent'] = last_class
            obj=ApiMethod.new(type)
            if ignore
              last_class.ignored_methods << obj
            else
              last_class.api_methods << obj
            end
          when 'innerclass'
            type['parent'] = last_class
            obj=ApiClass.new(type)
            if ignore
              last_class.ignored_innerclasses << obj
            else
              last_class.api_innerclasses << obj
            end            
          when 'innerenum'
            type['parent'] = last_class
            obj=ApiEnum.new(type)
            if ignore
              last_class.ignored_enums << obj
            else
              last_class.api_enums << obj
            end
          when 'attribute'
            type['parent'] = last_class
            obj=ApiAttribute.new(type)
            if ignore
              last_class.ignored_attributes << obj
            else
              last_class.api_attributes << obj
            end
          else
            raise "Malformed CSV Input: Node type " + type["node_type"] + " does not exist"
        end
      }
      namespaces
    end    
  end
end
end