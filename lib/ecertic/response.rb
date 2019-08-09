# frozen_string_literal: true

module Ecertic
  class Response
    attr_reader :http_response

    def initialize(http_response)
      @http_response = http_response
    end

    def body
      http_response[:body]
    end

    def raw_body
      http_response[:raw_body]
    end

    def headers
      http_response[:headers]
    end

    def status
      http_response[:status]
    end

    def self.from_faraday_response(faraday_response)
      http_response = {
        body: faraday_response.body,
        raw_body: faraday_response.env[:raw_body],
        headers: faraday_response.headers,
        status: faraday_response.status,
      }
      new(http_response)
    end
  end
end
