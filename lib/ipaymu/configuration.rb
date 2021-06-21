module Ipaymu
  class Configuration
    API_VERSION = "2" # :nodoc:
    DEFAULT_ENDPOINT = "api" # :nodoc:

    READABLE_ATTRIBUTE = [
      :va,
      :apiKey,
      :environment
    ]

    WRITABLE_ATTRIBUTES = [
      :va,
      :apiKey,
      :environment,
      :custom_user_agent,
      :endpoint,
      :http_open_timeout,
      :http_read_timeout,
      :logger,
    ]

    class << self
      attr_writer(*WRITABLE_ATTRIBUTES)
    end

    attr_reader(*READABLE_ATTRIBUTE)
    attr_writer(*WRITABLE_ATTRIBUTES)


    def self.environment=(env)
      env = env.to_sym
      unless [:sandbox, :production].include?(env)
        raise ArgumentError, "#{env.inspect} is not valid environment"
      end
      @environment = env
    end

    def self.Gateway
      Ipaymu::Gateway.new(instantiate)
    end

    def self.instantiate
      config = new(
        :custom_user_agent => @custom_user_agent,
        :endpoint => @endpoint
        :logger => logger
      )
    end

    def api_version 
      API_VERSION
    end

    def protocol # :nodoc:
      ssl? ? "https" : "http"
    end

    def http_open_timeout
      @http_open_timeout
    end

    def http_read_timeout
      @http_read_timeout
    end

    def base_url
      "#{protocol}://#{server}"
    end

    def logger
      @logger ||= self.class._default_logger
    end

    def server
      case @environment
      when :sandbox
        "sandbox.ipaymu.com"
      when :production
        "my.ipaymu.com"
      end
    end

    def ssl? # :nodoc:
      case @environment
      when :development, :integration
        false
      when :production, :sandbox
        true
      end
    end

    def user_agent # :nodoc:
      base_user_agent = "Braintree Ruby Gem #{Braintree::Version::String}"
      @custom_user_agent ? "#{base_user_agent} (#{@custom_user_agent})" : base_user_agent
    end

    def self._default_logger # :nodoc:
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      logger
    end

  end

end
