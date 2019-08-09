# frozen_string_literal: true

module Ecertic
  module API
    class OTPsService < Service
      def create(attributes, options = {})
        Ecertic::Utils.validate_mandatory_attributes(attributes, [:movil, :pdf_files])
        attributes[:pdf_files] = Utils.encode_files(attributes[:pdf_files])
        response = client.post("/sms", attributes, options)
        Resource::OTP::Request.new(response.body)
      end

      def status(token, options = {})
        attributes = { token: token }
        response = client.post("/status", attributes, options)
        Resource::OTP::Status.new(response.body)
      end
    end
  end
end
