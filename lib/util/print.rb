module EasySwig
  module Print

    def print_incl_files incl_files
      ret = ''
      ret << "\nGenerated Include Files: "
      incl_files.each { |f|
        ret << "\nincl_file:" + f.basename
        f.api_classes.each { |c|
          ret << "\t"+"Api Class:" + c.basename
          c.api_methods.each { |m|
            ret << "\t"+"\t"+"Api Method:" + m.basename
          }
          c.ignored_methods.each { |m|
            ret << "\t"+"\t"+"Ignored Method:" + m.basename
          }
        }
        f.ignored_classes.each { |c|
          ret << "\t"+"Ignored Class:" + c.basename
        # c.methods.each { |m|
        #  log "\t"+"\t"+"Ignored Method:" + m.name
        #}
        }
      }
      ret
    end

    def print_api_namespaces api_namespaces
      ret = ''
      api_namespaces.each { |api_ns|
        ret <<  print_api_namespace(api_ns)
      }
      ret
    end

    def print_api_namespace api_ns
      ret = '\n'
      ret << "\tNamespace: "+ api_ns+"\n"
      api_ns.api_functions.each { |f|
        ret <<  "\t\tFunction: "+f.basename+" Assoc: "+f.wrapped_node.to_s + '\n'
      }
      api_ns.api_variables.each { |f|
        ret <<  "\t\tVariable: "+f.basename+" Assoc: "+f.wrapped_node.to_s + '\n'
      }
      api_ns.api_enums.each { |f|
        ret <<  "\t\tEnum: "+f.basename+" Assoc: "+f.wrapped_node.to_s + '\n'
      }
      api_ns.api_classes.each { |c|
        ret << print_api_class(c)
      }
      ret
    end

    def print_api_class c
      ret = ''
      ret << "\t\tClass: " + c + "\n"
      c.api_methods.each { |m|
        ret << "\t\t\tMethod: "+m.basename+" Assoc: "+m.wrapped_node.to_s + '\n'
      }
      c.api_attributes.each { |m|
        ret << "\t\t\tAttribute : "+m.basename+" Assoc: "+m.wrapped_node.to_s + '\n'
      }
      c.api_enums.each { |m|
        ret << "\t\t\tEnum: "+m.basename+" Assoc: "+m.wrapped_node.to_s + '\n'
      }
      c.api_innerclasses.each { |m|
        ret << "\t\t\tInnerClass: "+m.basename+" Assoc: "+m.wrapped_node.to_s + '\n'
      }
      ret
    end
  end
end