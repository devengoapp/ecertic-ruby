# frozen_string_literal: true

require "ecertic/api/service"
require "ecertic/api/documents_service"
require "ecertic/api/otps_service"
require "ecertic/api/tokens_service"

module Ecertic
  module API
    def otps
      @services[:otps] ||= API::OTPsService.new(self)
    end

    def tokens
      @services[:tokens] ||= API::TokensService.new(self)
    end

    def documents
      @services[:documents] ||= API::DocumentsService.new(self)
    end
  end
end

