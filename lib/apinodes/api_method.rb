module EasySwig

  class ApiMethod < ApiFunction
    attr_accessor :match_constructor
    attr_accessor :match_static

    def constructor?
      @target_name==parent.target_name
    end

  end
end