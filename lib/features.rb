module EasySwig

  class Features

    def Features.create_instance(lang)
      ret = case lang
      when 'java'
        EasySwig::Java::JavaFeatures.new
      when 'csharp'
        EasySwig::Csharp::CsharpFeatures.new
      else
      	EasySwig::Csharp::CsharpFeatures.new
      end
      ret
    end

    def empty?
      false
    end

    def to_s
      ""
    end

    def to_str
      to_s
    end

    def infer_native_name(node)
      node.basename ||= node.target_name.gsub(".", "::").gsub(/_([a-z])/i) { |match|
        $1.upcase
      }
    end

    def infer_target_name(node)
      node.target_name ||= node.basename.gsub("::", ".")
    end
  end
end