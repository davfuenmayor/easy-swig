module EasySwig
  module HFilesManager

    class << self

      def assoc_headers(api_node)
        
        api_nodes = api_node.api_nodes
        hfile_hash = Hash.new

        api_nodes.each { |api_n|
          hfile = api_n.file

          next if hfile.nil?

          filename = hfile.name

          if hfile_hash[filename] == nil
            params = {'node_type' => 'file', 'features' => api_n.features }
            hfile_hash[filename] = IncFile.new(params).assoc_with_node(hfile)
            hfile_hash[filename].assoc_inner_node(api_node)
          end
          api_n.header_file = hfile_hash[filename]
          hfile_hash[filename].assoc_inner_node(api_n)
        }
        hfile_hash.each_value { |f|
          f.ignore_inner_nodes
          puts f.name
        }
        hfiles = hfile_hash.values
        hfiles
      end

      def sort_headers(files)
        sorted = []
        includes = {}
        while true

          break if files.empty?

          files_aux = files.map { |f| f.name }
          files = files.sort { |fx,fy| compare(fx, fy, files_aux) }
          includes = {}
          while true
            f = files.shift
            break if f.nil?

            incs = f.files_included.map { |x| x.name }
            t1 = files.select { |h| incs.include?(h.name) }
            t2 = sorted.select { |h| incs.include?(h.name) }
            t2.select! { |h| compare(h, f, files_aux) > 0}
            includes[f] = t1
            includes[f] << t2.flatten
            t1.each { |v| files.delete(v) }
            t2.each { |v| sorted.delete(v) }
            files -= includes[f]
          end
          sorted.push(*includes.keys)
          files = includes.values.flatten
        end
        sorted.reverse
      end

      def compare(fx, fy, files_set)
        num_incl_by_fx = num_included_by(fx, files_set)
        num_incl_by_fy = num_included_by(fy, files_set)
        num_incl_fx = num_includes(fx, files_set)
        num_incl_fy = num_includes(fy, files_set)
        if num_incl_by_fx == 0 && num_incl_by_fy == 0
        return num_incl_fy <=> num_incl_fx
        end
        return -1 if num_incl_by_fx == 0
        return  1 if num_incl_by_fy  == 0
        return (num_incl_fy - num_incl_by_fy) <=> (num_incl_fx - num_incl_by_fx)
      end

      def num_includes(file, files_set)
        file.files_included.map { |f| f.name }.select { |f| files_set.include?(f) }.size
      end

      def num_included_by(file, files_set)
        file.files_including.map { |f| f.name }.select{ |f| files_set.include?(f) }.size
      end
    end
  end
end