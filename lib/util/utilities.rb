class String
  def escape_heredoc
    this = dup
    lines = this.split(/\r\n|\r|\n/).select { |line| line.size > 0 }
    levels = lines.map do |line|
      match = line.match(/^( +)[^ ]+/)
      match ? match[1].size : 0
    end
    level = levels.min
    this.gsub!(/^#{' ' * level}/, '') if level > 0
    this
  end
end

module EasySwig	
module Util

    def lib_dir
      File.expand_path(File.dirname(__FILE__)+'/..')
    end

    def home_dir
      File.expand_path(lib_dir+"/..")
    end

    def output_dir
      @output_dir
    end
    
    def escape_all(typename)
    	return del_prefix_class(escape_template(escape_const_ref_ptr(typename)))
    end
    
    def escape_const_ref_ptr(typename)
      typename.gsub(/^ *const /,'').gsub(/ +(const)* *[&*]* *(const)* *$/,'').strip
    end
    
    def del_prefix_class(n) # Previuously escaped for const
	     n.gsub(%r{^[^<]*[:]}, "")
    end
    
    def is_primitive?(typename)
    	['void', 'bool', 'char', 'unsigned char', 
    	 'short', 'unsigned short', 'int', 'unsigned int',
    	 'long', 'unsigned long', 'long long', 'unsigned long long int', 
    	 'unsigned long long', 'float', 'double', 'long double',
    	 'size_t', 'uint32', 'uint8', 'uint16'].include?(typename)
    end
    
    def is_std?(typename) # TODO depends on language. What happens with templates?
    	['vector', 'string', 'pair', 'list', 
    	 'map', 'deque', 'multimap', 'set'].include?(typename)
    end
    
    def escape_template(typename)
      typename.gsub(/<.+$/,'').strip
    end

    def logs_dir
      @output_dir+"/logs"
    end

    def gen_dir
      File.expand_path(output_dir+"/gen")
    end

    def swig_dir
      File.expand_path(output_dir+"/swig")
    end

    def read_file file_name
      file = File.open(file_name, "r")
      data = file.read
      file.close
      return data
    end

    def write_file file_name, data
    	FileUtils::mkdir_p File.dirname(file_name)
      file = File.open(file_name, "w")
      count = file.write(data)
      file.close
      return count
    end   

    def rename_files (dir, find, ext='*', &block)
      if ext
        Dir.glob(%Q{#{dir}/*.#{ext}}) { |file|
          # do work on files ending in .ext in the desired directory
          name = File.basename(file, "."+ext)
          newname = name.gsub(find) { |match|
            puts match
            a = block.call(match, $1)
            a
          }
          File.rename(file, file.gsub(name, newname))
        }
      end
    end
  end
end