module EasySwig
  class SwigTask

    def initialize(config)
    	@config = config
      @target = @config.target_file
      @header_dir = @config.headers_dir
      @out_dir = @config.output_dir
      @lang = @config.lang
      @inc_dirs = @config.includes_dir

      if Dir.exists? @out_dir
        FileUtils.rm_r @out_dir
      end
      FileUtils.mkdir_p(@out_dir)

      @log=EasySwig::Logger.swig_log @out_dir
      @log.info { "Created SWIG output directory in #{@out_dir}" }
    end

    def run_swig

      swig_opts=%Q{-c++ -#{@lang} -v -Wall -debug-classes} # 
      saved_dir = Dir.pwd
      output_dir = @out_dir.clone
      ifiles = []
      current_dir = nil
      if File.directory? @target
        ifiles = Dir.entries(@target).select { |entry| File.extname(entry)=='.i' }
        output_dir << "/#{File.basename(@target)}"
        current_dir = @target
      else
        ifiles << File.basename(@target)
        current_dir = ::File.dirname(@target)
      end

      ifiles.each { |f|
        @log.info "\nExecuting SWIG command for file: " + f
        target_name = File.basename(f, '.i')
        odir = output_dir + "/#{target_name}"
        FileUtils.mkdir_p(odir)
        Dir.chdir current_dir
        incs = ""
        Dir.foreach(@header_dir) { |e|
        	subdir = File.absolute_path(e, @header_dir)
        	if File.directory?(subdir)
          	incs << "-I#{subdir} "
          end
        }
        @inc_dirs.each { |idir|
          incs << "-I#{idir} "
        }
        command=%Q{swig #{swig_opts} -namespace #{target_name} -outdir #{odir} #{incs} #{f} > swig_output 2>&1}
        @log.info command
        output=IO.popen(command)
        @log.debug { 'SWIG output:' }
        @log.debug { output.readlines.join }
        output.close
        FileUtils.mv("#{File.basename(f, '.i')}_wrap.cxx", output_dir)
      }
      Dir.chdir saved_dir
    end

    def dispose
      @log.close
    end

  end
end
