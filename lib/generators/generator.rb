module EasySwig

  class Generator
  	include Util

    attr_accessor :namespace_generator
    attr_accessor :class_generator
    attr_accessor :hfile_generator

    def self.create_instance(hfiles, api_namespace, config, log)
      ret = case config.lang
        when 'csharp'
          EasySwig::Csharp::CsharpGenerator.new(hfiles, api_namespace, config, log)
        when 'java'
          EasySwig::Java::JavaGenerator.new(hfiles, api_namespace, config, log)
      else
      EasySwig::Generator.new(hfiles, api_namespace, config, log)
      end
      ret
    end

    def initialize(hfiles, api_namespace, config, log)
      @config = config
      @gen_dir = @config.generate_dir + '/' + @config.lang
      @log = log
      @hfiles = hfiles
      @api_namespace = api_namespace
      @target_name = api_namespace.target_name
      @native_name = api_namespace.basename
      @native_gen_dir = "#{@gen_dir}/#{@native_name}"
      @all_types = {}
      @all_innerclasses = {}
      @all_friends = {}

      if Dir.exists?(@native_gen_dir)
        FileUtils.rm_r @native_gen_dir
      end
      FileUtils.mkdir_p @native_gen_dir
      @log.info { "Created Generator directory for #{@native_name} in #{@native_gen_dir}" }

      init_generators
    end

    def generate
      @log.info { 'Generating interface files...' }

      namespace_file = <<-IFILE.escape_heredoc
		       %module #{@target_name}

		       %include "standard_header.i"
		       %include "#{@config.custom_file}"

      IFILE
      namespace_file << @namespace_generator.new(@api_namespace).generate()

      @hfiles.each { |hfile|
        generate_ifile(hfile)
        ifile = to_ifile(hfile.name)
        namespace_file << %Q{%include "#{@native_name}/#{ifile}"\n}
      }
      write_file("#{@gen_dir}/#{namespace_filename(@native_name)}.i", namespace_file)
      @log.info { "Interface file #{@gen_dir}/#{namespace_filename(@native_name)}.i created" }
      namespace_filename(@native_name)
    end

    protected

    def init_generators
      @class_generator = EasySwig::ClassGenerator
      @namespace_generator = EasySwig::NamespaceGenerator
      @hfile_generator = EasySwig::HFileGenerator
    end

    def to_ifile(filename)
      extension = File.extname(filename)
      filename.gsub(extension, '.i')
    end

    def generate_ifile(hfile)
      swig_file = <<-IFILE.escape_heredoc
	      %module #{@target_name}

				%include "standard_header.i"
				%include "custom_config.i"

				// Include headers:
				%{
				#include "#{hfile.name}"
				%}

				// Rename and ignore members:

      IFILE

      @log.debug { "Generating renames for #{hfile.name} ..." }

      swig_file << @hfile_generator.new(hfile).generate

      class_generators = []

      hfile.api_classes.each { |api_cls|
        class_gen_instance = @class_generator.new(api_cls, @all_types, @all_innerclasses, @all_friends)
        class_generators << class_gen_instance
        swig_file << class_gen_instance.process_types
        swig_file << class_gen_instance.gen_friends
        swig_file << class_gen_instance.gen_methods
        swig_file << class_gen_instance.gen_attributes
        swig_file << class_gen_instance.gen_enums
        swig_file << class_gen_instance.gen_innerclasses
        swig_file << class_gen_instance.gen_type_templates
      }
      swig_file << %Q{%include "#{hfile.name}"}
      
      ifile = to_ifile(hfile.name)
      write_file(%Q{#{@native_gen_dir}/#{ifile}}, swig_file)
      @log.info { "Interface file #{@native_name}/#{ifile} created" }
    end

    def namespace_filename native_name
      "ns_#{native_name}"
    end

  end
end 