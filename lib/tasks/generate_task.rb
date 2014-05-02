module EasySwig

  class GenerateTask
    include Util
    include Print

    def initialize(config)
      @config = config
      @gen_dir = @config.generate_dir+'/'+@config.lang
      @generators = {}

      FileUtils.rm_r @gen_dir if Dir.exists?(@gen_dir)
      FileUtils.mkdir_p @gen_dir
      FileUtils.cp "#{home_dir}/resources/#{@config.lang}/standard_header.i", "#{@gen_dir}/standard_header.i"
      FileUtils.cp @config.custom_file, "#{@gen_dir}/custom_config.i" if @config.custom_file
			FileUtils.cp "#{home_dir}/resources/swig-patches/attribute.i", "#{@gen_dir}/attribute.i"

      @log=EasySwig::Logger.gen_log(@gen_dir)
      @log.info { "Created Generator directory for #{@native_name} in #{@node_gen_dir}" }
    end

    def generate
      module_file = <<-IFILE.escape_heredoc
	      %module #{@config.module_name}

	      %include "standard_header.i"
	      %include "#{@config.custom_file}"
	      %include "attribute.i"

      IFILE

      @log.info { "Parsing CSV file #{@csv_file} ..." }
      csv_parser = EasySwig::Readers::CsvParser.new(@config.csv_file, @config.lang)
      
      @log.info { "Parsed CSV file. Number of entries: #{csv_parser.table.size}" }

      @log.info { "Generating Namespaces from CSV file #{@csv_file}..." }
      api_namespaces = csv_parser.namespaces_from_csv
      @log.info { "Namespaces generated in memory: \n\t\tNamespaces: " + (api_namespaces.map{|n| n.basename}.join(', ')) }
      @log.debug { "Namespace contents:\n\t\t\t\t" + print_api_namespaces(api_namespaces) }

      api_namespaces.each do |api_namespace|

        @log.info { "Parsing namespace from C++ files..." }
        namespace = Doxyparser::parse_namespace(api_namespace.basename, @config.doxy_dir+'/xml')
        @log.info { "C++ Namespace parsed" }

        @log.info { "Associating namespace tree (classes, structs, enums...) with the corresponding Doxygen tree..." }
        api_namespace.assoc_with_node(namespace)
        @log.info { "Namespace Tree associated" }
        @log.debug { print_api_namespace(api_namespace) }
        
        # If there are no classes in this namespace things get a bit tricky
        conf_doxy_dir = @config.doxy_dir
				if api_namespace.api_classes.empty?
					api_namespace.define_singleton_method(:file) { 
						Doxyparser::parse_file(api_namespace.basename + '.h', conf_doxy_dir+"/xml")
					}
				end

        @log.info { "Associating and sorting header files for all sub-nodes of: #{api_namespace.node_type} #{api_namespace.name}..." }
        hfiles = EasySwig::HFilesManager.assoc_headers(api_namespace)
        @log.info { "Header files associated" }
        hfiles = EasySwig::HFilesManager.sort_headers(hfiles)
        @log.info { "Header files sorted" }
        @log.debug { print_incl_files(hfiles) }

        native_name = api_namespace.basename # Name of module (C++ namespace)
        target_name = api_namespace.target_name # Name of target namespace

        @generators[api_namespace] = Generator.create_instance(hfiles, api_namespace, @config, @log)

        @log.info { "Generating SWIG configuration files..." }
        gen_node_name = @generators[api_namespace].generate
        @log.info { "SWIG configuration files generated" }
        module_file << %Q{%include "#{gen_node_name}.i"\n}
      end
      write_file(%Q{#{@gen_dir}/#{@config.module_name}.i}, module_file)
    end

    def dispose
      @log.close
    end
  end
end