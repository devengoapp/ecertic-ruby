# frozen_string_literal: true

module Ecertic
  module Resource
    class OTP < Base
      attr_accessor :id
      attr_accessor :customid
      attr_accessor :clientToken
      attr_accessor :pdf_shortUrl
      attr_accessor :html_shortUrl
    end
  end
end
