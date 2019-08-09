# frozen_string_literal: true

module Ecertic
  module Resource
    module Token
      class Instance < Base
        attr_accessor :html
        attr_accessor :checks
        attr_accessor :uuid
      end
    end
  end
end
