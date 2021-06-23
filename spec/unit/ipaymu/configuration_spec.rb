require "stringio"

require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Ipaymu::Configuration do
  before do
    @orgin_va = Ipaymu::Configuration.va
    @origin_apikey = Ipaymu::Configuration.apikey
    @origin_environment = Ipaymu::Configuration.environment
  end

  after do
    Ipaymu::Configuration.va = @orgin_va
    Ipaymu::Configuration.apikey = @origin_apikey
    Ipaymu::Configuration.environment = @origin_environment
    Ipaymu::Configuration.endpoint = Ipaymu::Configuration::DEFAULT_ENDPOINT
  end

  describe "initialize" do
    it "accept va account" do
      config = Ipaymu::Configuration.new(
        :va => "va",
        :apikey => "apikey",
      )

      config.va.should == "va"
      config.apikey.should == "apikey"
    end
  end

  describe "server" do
    it "is my.ipaymu.com for production" do
      Ipaymu::Configuration.environment = :production
      Ipaymu::Configuration.instantiate.server.should == "my.ipaymu.com"
    end

    it "is sandbox.ipaymu.com for sandbox" do
      Ipaymu::Configuration.environment = :sandbox
      Ipaymu::Configuration.instantiate.server.should == "sandbox.ipaymu.com"
    end
  end

  describe "signature_service" do
    it "has a signature service initialized with the private key" do
      config = Ipaymu::Configuration.new(:apikey => "secret_key")

      config.signature_service.key.should == "secret_key"
    end
  end
end