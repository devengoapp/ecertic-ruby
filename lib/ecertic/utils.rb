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

    def self.log_error(message, data = {})
      return unless should_log_for_level(Ecertic::LEVEL_ERROR)

      log_internal(message, data, color: :red, level: Ecertic::LEVEL_ERROR, logger: Ecertic.logger, out: $stderr)
    end

    def self.log_info(message, data = {})
      return unless should_log_for_level(Ecertic::LEVEL_INFO)

      log_internal(message, data, color: :cyan, level: Ecertic::LEVEL_INFO, logger: Ecertic.logger, out: $stdout)
    end

    def self.log_debug(message, data = {})
      return unless should_log_for_level(Ecertic::LEVEL_DEBUG)

      log_internal(message, data, color: :orange, level: Ecertic::LEVEL_DEBUG, logger: Ecertic.logger, out: $stdout)
    end

    def self.should_log_for_level(level)
      Ecertic.logger || Ecertic.log_level && Ecertic.log_level <= level
    end

    COLOR_CODES = {
      black: 0,
      red: 1,
      orange: 4,
      cyan: 6,
      default: 9,
    }.freeze
    private_constant :COLOR_CODES

    def self.colorize(val, color, isatty)
      return val unless isatty

      mode = 0
      foreground = 30 + COLOR_CODES.fetch(color)
      background = 40 + COLOR_CODES.fetch(:default)

      "\033[#{mode};#{foreground};#{background}m#{val}\033[0m"
    end
    private_class_method :colorize

    def self.level_name(level)
      case level
      when LEVEL_DEBUG then "debug"
      when LEVEL_ERROR then "error"
      when LEVEL_INFO  then "info"
      else level
      end
    end
    private_class_method :level_name

    def self.log_internal(message, data = {}, color: nil, level: nil, logger: nil, out: nil)
      data_str = data.reject { |_k, v| v.nil? }.map do |(k, v)|
        format("%<key>s=%<value>s", key: colorize(k, color, logger.nil? && !out.nil? && out.isatty), value: v)
      end.join(" ")

      if !logger.nil?
        logger.log(level, format("message=%<message>s %<data_str>s", message: message, data_str: data_str))
      elsif out.isatty
        out.puts format("%<level>s %<message>s %<data_str>s",
                        level: colorize(level_name(level).ljust(5).upcase, color, out.isatty),
                        message: message,
                        data_str: data_str)
      else
        out.puts format("message=%<message>s level=%<level>s %<data_str>s",
                        message: message,
                        level: level_name(level),
                        data_str: data_str)
      end
    end
    private_class_method :log_internal
  end
end
