module Ipaymu
  module DataSign
    def self.encrypt(data)
      # convert data to json string
      sha256 = OpenSSL::Digest.new("SHA256")
      # https://stackoverflow.com/questions/48755970/ruby-pack-and-unpack-how-is-this-hexadecimal-conversion-being-done-could-use-s
      sha256.digest(data.to_json).unpack("H*")[0]
    end

    def self.signature(data)
      body_encrypt = encrypt(data)
      va = Configuration.va
      apikey = Configuration.apikey
      "POST:#{va}:#{body_encrypt}:#{apikey}"
    end
  end
end