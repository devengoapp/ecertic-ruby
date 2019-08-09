# frozen_string_literal: true

module Ecertic
  module Resource
    class Base
      def initialize(attributes = {})
        attributes.each do |key, value|
          m = "#{key}=".to_sym
          send(m, value) if respond_to?(m)
        end
      end
    end
  end
end
