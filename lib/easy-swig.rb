require 'rubygems'
require '/home/david/workspace/ruby-doxygen-parser/lib/doxyparser'
require 'fileutils'
require 'logger'

require_relative 'config'
require_relative 'util/utilities'
require_relative 'util/print'
require_relative 'util/logger'
require_relative 'util/query'
require_relative 'generators/properties'
require_relative 'generators/generator_util'
require_relative 'generators/class_generator'
require_relative 'generators/namespace_generator'
require_relative 'generators/hfile_generator'
require_relative 'generators/generator'
require_relative 'features'
require_relative 'apinodes/api_node'
require_relative 'apinodes/api_namespace'
require_relative 'apinodes/api_function'
require_relative 'apinodes/api_class'
require_relative 'apinodes/api_method'
require_relative 'apinodes/api_group'
require_relative 'apinodes/inc_file'
require_relative 'apinodes/api_variable'
require_relative 'apinodes/api_attribute'
require_relative 'apinodes/api_enum'

require_relative 'csharp/generators/csharp_generator'
require_relative 'csharp/generators/csharp_namespace_generator'
require_relative 'csharp/generators/csharp_class_generator'
require_relative 'csharp/csharp_features'

require_relative 'tasks/swig_task'

require_relative 'tasks/doxygen_task'
require_relative 'readers/csv_parser'
require_relative 'tasks/hfiles_manager'
require_relative 'tasks/generate_task'

module EasySwig
  class << self

		# Parses header files (.h) and generates intermediate XML representation using Doxygen (Doxyparser)
		# For more information consult Doxyparser documentation {Doxyparser::gen_xml_docs}
		# @param [Config] config optional configuration for personalized settings. If nothing given, {Config} defaults used
    def doxygen(config = EasySwig::Config.new)
      task = DoxygenTask.new(config)
      task.generate
      task.dispose
    end

    # Generates SWIG Interface Files (.i) from Doxygen intermediate XML representation.
    # 	This process is configured using a specially crafted CSV file (see documentation),
    #   A subdirectory for every found namespace is created and here are saved the generated .i swig files
    # @param [Config] config optional configuration for personalized settings. If nothing given, {Config} defaults used 
    def generate(config = EasySwig::Config.new)
      task = GenerateTask.new(config)
      task.generate
      task.dispose      
    end

    # Runs SWIG against the specified target interface files (.i) And generated wrappers in the output directory (see {Config})
    # @param [Config] config optional configuration for personalized settings. If nothing given, {Config} defaults used
    def swig(config = EasySwig::Config.new)
      task = SwigTask.new(config)
      task.run_swig
      task.dispose
    end
  end
end
