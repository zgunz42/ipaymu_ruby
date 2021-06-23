unless defined?(SPEC_HELPER_LOADED)
  SPEC_HELPER_LOADED = true
  project_root = File.expand_path(File.dirname(__FILE__) + "/..")
  require "rubygems"
  require "bundler/setup"
  require "libxml"
  require "rspec"
  require "pry"

  braintree_lib = "#{project_root}/lib"
  $LOAD_PATH << braintree_lib
  require "ipaymu"
  # require File.dirname(__FILE__) + "/oauth_test_helper"

  Ipaymu::Configuration.environment = :sandbox
  Ipaymu::Configuration.va = "va"
  Ipaymu::Configuration.apikey = "apikey"
  Ipaymu::Configuration.paymethod = :directpay
  logger = Logger.new("/dev/null")
  logger.level = Logger::INFO
  Ipaymu::Configuration.logger = logger

  module Kernel
    alias_method :original_warn, :warn
    def warn(message)
      return if message =~ /^\[DEPRECATED\]/
      original_warn(message)
    end

  end
end

RSpec.configure do |config|

  if ENV["JUNIT"] == "1"
    config.add_formatter("RspecJunitFormatter", "tmp/build/ipaymu-ruby.#{rand}.junit.xml")
    config.add_formatter("progress")
  end

  config.expect_with :rspec do |expect|
    expect.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mock|
    mock.syntax = [:should, :expect]
  end
end