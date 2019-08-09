# frozen_string_literal: true

module Ecertic
  # Error is the base error from which all other more specific Ecertic errors derive.
  class Error < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_headers
    attr_reader :http_body
    attr_reader :response

    def initialize(message = nil, http_status: nil, http_headers: nil, http_body: nil, response: nil)
      @message = message
      @http_status = http_status || response&.status
      @http_headers = http_headers || response&.headers
      @http_body = http_body || response&.body
      @response = response
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end
  end

  # InvalidRequestError is raised when a request is initiated with invalid parameters.
  class InvalidRequestError < Error
  end

  # AuthenticationError is raised when invalid credentials are used to connect Ecertic's servers.
  class AuthenticationError < Error
  end

  # APIConnectionError is raised in the event that the SDK can't connect to Ecertic's servers.
  class APIConnectionError < Error
  end

  # SignatureVerificationError is raised when the decryption for a callback fails
  class SignatureVerificationError < Error
  end

  # APIError is a generic error that may be raised in cases where none of the ther named errors cover the problem.
  class APIError < Error
  end
end
