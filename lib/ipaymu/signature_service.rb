module Ipaymu
  class SignatureService
    attr_reader :key

    def initialize(key, digest=Ipaymu::SHA256Digest)
      @key = key
      @digest = digest
    end

    def sign(data)
      str_to_sign = DataSign.signature(data)
      hash(str_to_sign)
    end

    def hash(data)
      @digest.hexdigest(@key, data)
    end
  end
end