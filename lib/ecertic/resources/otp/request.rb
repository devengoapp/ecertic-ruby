# frozen_string_literal: true

module Ecertic
  module Resource
    module OTP
      class Request < Base
        attr_accessor :id
        attr_accessor :customid
        attr_accessor :clientOtp
        attr_accessor :clientToken
        attr_accessor :pdf_shortUrl
        attr_accessor :html_shortUrl
        alias uuid id
        alias otp clientOtp
        alias token clientToken
        alias pdf_url pdf_shortUrl
        alias html_url html_shortUrl
      end
    end
  end
end
