module EasySwig

  class DoxygenTask
    include EasySwig
    
    def initialize config
    	@config = config
      if Dir.exists?(@config.doxy_dir)
        FileUtils.rm_r @config.doxy_dir
      end
      FileUtils.mkdir_p @config.doxy_dir

      @log = EasySwig::Logger.doxy_log(@config.doxy_dir)
      @log.info { "Created Doxygen directory in #{@config.doxy_dir}" }
    end

    def generate
      @log.info { "Creating Doxygen documentation in directory: #{@config.doxy_dir} ..." }
      headers_dirs = [@config.headers_dir]   
      output = Doxyparser::gen_xml_docs(headers_dirs, @config.doxy_dir, true, @config.includes_dir, @config.html, @config.stl_support)
      @log.info { 'Doxygen documentation created at: '+ @config.doxy_dir}
    end

    def dispose
      @log.close
    end
  end
end