# frozen_string_literal: true

module Ecertic
  module Resource
    module Token
      class Validation < Base
        include Statusable
        attr_accessor :msg
        alias message msg
      end
    end
  end
end
