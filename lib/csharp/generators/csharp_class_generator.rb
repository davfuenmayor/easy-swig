module EasySwig

  class CSharpClassGenerator < ClassGenerator

    def gen_methods
      swig_file = super
      # Takes the opportunity to also apply partial class typemaps
      if @api_class.features.partial
        swig_file << %Q{\n%typemap(csclassmodifiers) #{@api_class.name} "public partial class"\n}
      end
      swig_file
    end
  end
end