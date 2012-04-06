# -*- encoding : utf-8 -*-
# Code for the hash functions mostly copied from the metasploid project
# from file lib/rex/proto/ntlm/crypt.rb
#
# some minor additions and changes done by johnyb to fit for this project.

module NTLM
  module Hashes
    def self.lm_hash password
      keys = gen_keys(password.upcase.ljust(14, "\0"))
      apply_des(CONST::LM_MAGIC, keys).join.bytes.map { |b| b.to_s(16) }.join.upcase
    end

    def self.nt_hash password
      OpenSSL::Digest::MD4.hexdigest(encoded_password(password)).upcase
    end

    private
    module CONST
      LM_MAGIC = "KGS!@\#$%"
    end

    def self.gen_keys(str)
      str.scan(/.{7}/).map{ |key| des_56_to_64(key) }
    end

    def self.des_56_to_64(ckey56s)
      ckey64 = []
      ckey56 = ckey56s.unpack('C*')
      ckey64[0] = ckey56[0]
      ckey64[1] = ((ckey56[0] << 7) & 0xFF) | (ckey56[1] >> 1)
      ckey64[2] = ((ckey56[1] << 6) & 0xFF) | (ckey56[2] >> 2)
      ckey64[3] = ((ckey56[2] << 5) & 0xFF) | (ckey56[3] >> 3)
      ckey64[4] = ((ckey56[3] << 4) & 0xFF) | (ckey56[4] >> 4)
      ckey64[5] = ((ckey56[4] << 3) & 0xFF) | (ckey56[5] >> 5)
      ckey64[6] = ((ckey56[5] << 2) & 0xFF) | (ckey56[6] >> 6)
      ckey64[7] =  (ckey56[6] << 1) & 0xFF
      ckey64.pack('C*')
    end

    def self.apply_des(plain, keys)
      dec = OpenSSL::Cipher::DES.new
      keys.map do |k|
        dec.key = k
        dec.encrypt.update(plain)
      end
    end

    def self.encoded_password pw
      if pw.respond_to?"encode"
        pw.encode("utf-16le", "utf-8")
      else
        Iconv.iconv("UTF-16le", "UTF-8", pw).join
      end
    end
  end
end

