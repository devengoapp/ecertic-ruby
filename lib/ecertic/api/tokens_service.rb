# frozen_string_literal: true

module Ecertic
  module API
    class TokensService < Service
      def retrieve(token, options = {})
        attributes = { token: token }
        response = client.post("/token", attributes, options)
        Resource::Token::Instance.new(response.body)
      end

      def validate(token, otp, options = {})
        attributes = { token: token, otp: otp }
        response = client.post("/validate", attributes, options)
        Resource::Token::Validation.new(response.body)
      end
    end
  end
end
