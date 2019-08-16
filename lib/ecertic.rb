# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "logger"
require "base64"
require "json"

require "ecertic/version"
require "ecertic/api"

require "ecertic/resources/base"
require "ecertic/resources/document"
require "ecertic/resources/statusable"
require "ecertic/resources/otp/request"
require "ecertic/resources/otp/status"
require "ecertic/resources/token/instance"
require "ecertic/resources/token/validation"

require "ecertic/errors"
require "ecertic/default"
require "ecertic/callback"
require "ecertic/utils"
require "ecertic/response"
require "ecertic/client"

module Ecertic
  @api_base = "https://api.otpsecure.net/"

  @log_level = nil
  @logger = nil

  LEVEL_DEBUG = Logger::DEBUG
  LEVEL_ERROR = Logger::ERROR
  LEVEL_INFO = Logger::INFO

  class << self
    attr_accessor :api_base, :api_key, :secret
  end

  def self.log_level
    @log_level
  end

  def self.log_level=(val)
    # Support text values for easy log level definition from command line via export
    val = case val
          when "debug"
            LEVEL_DEBUG
          when "info"
            LEVEL_INFO
          else
            val
          end
    if !val.nil? && ![LEVEL_DEBUG, LEVEL_ERROR, LEVEL_INFO].include?(val)
      raise ArgumentError,
            "log_level should only be set to `nil`, `debug` or `info`"
    end
    @log_level = val
  end

  def self.logger
    @logger
  end

  def self.logger=(val)
    @logger = val
  end
end

Ecertic.log_level = ENV["ECERTIC_LOG"] unless ENV["ECERTIC_LOG"].nil?
