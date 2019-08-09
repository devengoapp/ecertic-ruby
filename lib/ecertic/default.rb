# frozen_string_literal: true

module Ecertic
  module Default
    BASE_URL = "https://api.otpsecure.net"
    USER_AGENT = "ecertic-ruby/#{VERSION}"

    class << self
      def keys
        @keys ||= [ :base_url, :apikey, :secret, :user_agent ]
      end

      def options
        Hash[keys.map { |key| [key, send(key)] }]
      end

      def base_url
        ENV["ECERTIC_BASE_URL"] || BASE_URL
      end

      def apikey
        ENV["ECERTIC_APIKEY"]
      end

      def secret
        ENV["ECERTIC_SECRET"]
      end

      def user_agent
        ENV["ECERTIC_USER_AGENT"]
      end
    end
  end
end
