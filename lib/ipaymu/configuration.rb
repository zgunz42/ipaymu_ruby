module Ipaymu
  class Configuration
    API_VERSION = "2" # :nodoc:
    DEFAULT_ENDPOINT = "api" # :nodoc:

    READABLE_ATTRIBUTES = [
      :va,
      :apikey,
      :paymethod,
      :environment
    ]

    WRITABLE_ATTRIBUTES = [
      :va,
      :apikey,
      :paymethod,
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

    attr_reader(*READABLE_ATTRIBUTES)
    attr_writer(*WRITABLE_ATTRIBUTES)

    def self.expectant_reader(*attributes) # :nodoc:
      attributes.each do |attribute|
        (class << self; self; end).send(:define_method, attribute) do
          attribute_value = instance_variable_get("@#{attribute}")
          raise ConfigurationError.new("Braintree::Configuration.#{attribute.to_s} needs to be set") if attribute_value.nil? || attribute_value.to_s.empty?
          attribute_value
        end
      end
    end
    expectant_reader(*READABLE_ATTRIBUTES)


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
        :endpoint => @endpoint,
        :logger => logger,
        :va => va,
        :apikey => apikey,
        :paymethod => paymethod,
        :environment => environment,
      )
    end

    def initialize(options = {})
      WRITABLE_ATTRIBUTES.each do |attr|
        instance_variable_set "@#{attr}", options[attr]
      end

      @environment = @environment.to_sym if @environment

      # parser = Braintree::CredentialsParser.new
      # if options[:client_id] || options[:client_secret]
      #   parser.parse_client_credentials(options[:client_id], options[:client_secret])
      #   @client_id = parser.client_id
      #   @client_secret = parser.client_secret
      #   @environment = parser.environment
      # elsif options[:access_token]
      #   parser.parse_access_token(options[:access_token])

      #   _check_for_mixed_environment(options[:environment], parser.environment)

      #   @access_token = parser.access_token
      #   @environment = parser.environment
      #   @merchant_id = parser.merchant_id
      # else
      #   @merchant_id = options[:merchant_id] || options[:partner_id]
      # end
    end

    # def _check_for_mixed_credentials(options)
    #   if (options[:client_id] || options[:client_secret]) && (options[:public_key] || options[:private_key])
    #     raise ConfigurationError.new("Braintree::Gateway cannot be initialized with mixed credential types: client_id and client_secret mixed with public_key and private_key.")
    #   end
    # end

    def api_version
      API_VERSION
    end

    def http_open_timeout
      @http_open_timeout
    end

    def http_read_timeout
      @http_read_timeout
    end

    def base_url
      "https://#{server}/api/v#{api_version}"
    end

    def logger
      @logger ||= self.class._default_logger
    end

    def self.logger
      @logger ||= _default_logger
    end

    def self.signature_service
      instantiate.signature_service
    end

    def server
      case @environment
      when :sandbox
        "sandbox.ipaymu.com"
      when :production
        "my.ipaymu.com"
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

    def signature_service
      @signature_service ||= SignatureService.new(@apikey)
    end

  # General API
  #  $this->balance          = $base . '/balance';

  #  $this->transaction      = $base . '/transaction';
  #  $this->history          = $base . '/history';
  #  $this->banklist         = $base . '/banklist';


  # Payment API 
  #  $this->redirectpayment  = $base . '/payment';
  #  $this->directpayment    = $base . '/payment/direct';

  # COD Payment
  #  $this->codarea          = $base . '/cod/getarea';
  #  $this->codrate          = $base . '/cod/getrate';
  #  $this->codpickup        = $base . '/cod/pickup';
  #  $this->codpayment       = $base . '/payment/cod';

  # COD Tracking
  #  $this->codawb           = $base . '/cod/getawb';
  #  $this->codtracking      = $base . '/cod/tracking';
  #  $this->codhistory       = $base . '/cod/history';

  end

end
