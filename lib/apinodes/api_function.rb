module EasySwig

  class ApiFunction < ApiNode
    attr_accessor :match_signature
    attr_accessor :match_type

    def api_nodes
      self
    end

  end

end