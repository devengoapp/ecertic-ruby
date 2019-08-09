# frozen_string_literal: true

module Ecertic
  module Resource
    module Statusable
      MAPPINGS = {
        sent: "ENVIADO",
        sending_error: "ERROR_ENVIO",
        started: "INICIADO",
        ok: "OTP_OK",
        error: "OTP_NOK",
        signed: "SIGNED",
        sandbox: "SANDBOX",
      }.freeze

      MAPPINGS.keys.each do |mapping|
        define_method("#{mapping}?") { status == MAPPINGS[mapping] }
      end
      attr_accessor :status
    end
  end
end
