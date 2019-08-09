# frozen_string_literal: true

module Ecertic
  module API
    class DocumentsService < Service
      def pdf(document_id, options = {})
        client.get("/pdf/#{document_id}/0", options)
      end

      def html(document_id, options = {})
        client.get("/html/#{document_id}/0", options)
      end

      def signed(document_id, options = {})
        client.get("/signed/#{document_id}/0", options)
      end
    end
  end
end
