# frozen_string_literal: true

module Ecertic
  module Utils
    def self.validate_mandatory_attributes(attributes, required)
      required.each do |name|
        attributes&.key?(name) || raise(ArgumentError, ":#{name} is required")
      end
    end

    def self.encode_files(files)
      files.map do |file|
        {
          pdf_filename: File.basename(file.path),
          pdf_content: Base64.strict_encode64(file.read),
        }
      end
    end
  end
end
