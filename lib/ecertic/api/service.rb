# frozen_string_literal: true

module Ecertic
  module API
    class Service
      attr_reader :client

      def initialize(client)
        @client = client
      end
    end
  end
end
