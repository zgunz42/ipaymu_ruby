require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

class FakeDigest
  def self.hexdigest(key, string)
    "#{string}_signed_with_#{key}"
  end
end

describe Ipaymu::SignatureService do
  describe "sign" do
    it "signs the data with its key" do
      service = Ipaymu::SignatureService.new("my_key", FakeDigest)
      service.sign({:foo => "foo bar"}).should == "POST:va:8143f5dc13b5501bfeae229cf4fa15d926b43cefae16d58fdefefc996a7fc2a6:apikey_signed_with_my_key"
    end
  end

  describe "hash" do
    it "hashes the string with its key" do
      hash = Ipaymu::SignatureService.new("my_key", FakeDigest).hash("foo")
      hash.should == "foo_signed_with_my_key"
    end
  end
end