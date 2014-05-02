module EasySwig
  module Csharp

    class CsharpGenerator < EasySwig::Generator

      def initialize(hfiles, api_namespace, config, log)
        super(hfiles, api_namespace, config, log)
      end

      def init_generators
        @class_generator = EasySwig::CSharpClassGenerator
        @namespace_generator = EasySwig::CSharpNamespaceGenerator
        @hfile_generator = EasySwig::HFileGenerator
      end
    end
  end
end
