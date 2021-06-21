module Ipaymu
  class Gateway
    attr_reader :config

    def initialize(config)
      if config.is_a?(Hash)
        @config = Configuration.new config
      elsif config.is_a?(Ipaymu::Configuration)
        @config = config
      else
        raise ArgumentError, "config is an invalid type"
      end
    end
    
  end
  
end