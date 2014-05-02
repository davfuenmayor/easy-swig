module EasySwig

  class ApiNode
  	include Util
  	
    attr_accessor :basename
    attr_accessor :target_name
    attr_accessor :directory
    attr_accessor :parent
    attr_accessor :header_file
    attr_reader :wrapped_node
    attr_accessor :node_type
    attr_accessor :match
    attr_accessor :features
    attr_accessor :ignore
    
    # Redirects calls to lang_settings before completely initialized and to
    # wrapper_node afterwards
    def method_missing sym, *args
      if @wrapped_node.nil?
      @features.send sym, *args
      else
      @wrapped_node.send sym, *args
      end
    end

    def to_str
      if @fullname==nil
        @fullname=fullname
      end
      @node_type+"::"+@fullname
    end

    def fullname
      if @parent == nil
      return @basename
      else
        return @parent.fullname+"::"+@basename
      end
    end

    def initialize(hash)
      hash.each_key { |k|
        send(k.to_s+"=", hash[k]) # TODO features must always come first in the
        # hash
      }
      @basename || @features.infer_native_name(self) unless @target_name.nil?
      self
    end

    def assoc_with_node(node)
      @wrapped_node = node
      EasySwig::Logger.log %Q{Associating target #{@node_type}: #{@target_name} with native node: #{name}}
      @basename = node.basename
      @target_name || @features.infer_target_name(self)
      self
    end

    def assoc_functions(all_functions, api_functions, ignored_functions)
      api_mets=[]
      new_mets=[]
      del_mets=[]
      api_functions.each { |f|
        all_found=all_functions.select { |func| func.basename == f.basename }
        if all_found.empty?
          EasySwig::Logger.log("WARNING: Function not found: #{f.to_str}")
        del_mets << f
        next
        end
        if all_found.size > 1
          EasySwig::Logger.log("WARNING: Found several matching functions for #{f.to_str}: "+all_found.map { |func| func.basename+func.args }.join(" -- ")+"All of them will be matched")
          all_found[1..-1].each { |found|
            new_met=f.clone
            new_met.assoc_with_node found
            new_mets << new_met
          }
        end
        f.assoc_with_node all_found[0]
        api_mets.push(*all_found)
      }
      api_functions.reject! { |f| del_mets.include?(f)}      
      api_functions.push(*new_mets)
      ignored_functions.push(*(all_functions - api_mets));
    end

    def assoc_members(all_members, api_members, ignored_members)
      api_mbrs=[]
      del_mbrs=[]

      api_members.each { |s|
        found=nil
        all_found=all_members.select { |str| str.basename == s.basename }
        if all_found.empty?
          EasySwig::Logger.log("WARNING: Member not found: #{s.to_str}")
          del_mbrs << s
          next
        end
        if all_found.size > 1
          EasySwig::Logger.log("WARNING: Found several matching members for #{s.to_str}: "+all_found.join(" -- ")+" Only the first one will be matched")
        end
        found=all_found[0]
        s.assoc_with_node found
        api_mbrs.push found
      }
      api_members.reject! { |m| del_mbrs.include?(m) }
      ignored_members.push(*(all_members - api_mbrs));
    end
  end
end
