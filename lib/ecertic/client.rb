# frozen_string_literal: true

module Ecertic
  class Client
    include Ecertic::API
    attr_accessor :apikey, :secret, :user_agent, :connection

    def initialize(options = {})
      defaults = Ecertic::Default.options
      Ecertic::Default.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || defaults[key])
      end
      @connection = connection || self.class.default_connection
      @services = {}
    end

    def self.default_connection
      Thread.current[:ecertic_client_default_connection] ||= begin
        Faraday.new do |builder|
          builder.use Faraday::Response::RaiseError
          builder.response :json,
                           content_type: /\bjson$/,
                           preserve_raw: true, parser_options: { symbolize_names: true }
          builder.adapter :net_http_persistent
        end
      end
    end

    def base_url
      @base_url.chomp("/")
    end

    def get(path, options = {})
      execute :get, path, nil, options.to_h
    end

    def post(path, data = nil, options = {})
      execute :post, path, data, options
    end

    def execute(method, path, data = nil, options = {})
      request(method, path, data, options)
    end

    def request(method, path, data = nil, options = {})
      request_options = request_options(method, options, data)
      uri = "#{base_url}#{path}"

      begin
        request_start = Time.now
        log_request(method, path, request_options[:body], request_options[:headers])
        response = connection.run_request(method, uri, request_options[:body], request_options[:headers]) do |req|
          # req.options.open_timeout = Ecertic.open_timeout
          # req.options.timeout =  Ecertic.read_timeout
        end
        log_response(request_start, method, path, response.status, response.body)
        response
      rescue StandardError => e
        log_response_error(request_start, e, method, path)
        case e
        when Faraday::ClientError
          if e.response
            handle_error_response(e.response)
          else
            handle_network_error(e)
          end
        else
          raise
        end
      end
      Ecertic::Response.from_faraday_response(response)
    end

    private def handle_network_error(error)
      Ecertic::Utils.log_error("Ecertic network error", error_message: error.message)

      message = case error
                when Faraday::ConnectionFailed
                  "Unexpected error communicating when trying to connect to " \
                  "Ecertic. You may be seeing this message because your DNS is not " \
                  "working. To check, try running `host http://api.otpsecure.net` from the " \
                  "command line."

                when Faraday::SSLError
                  "Could not establish a secure connection to Ecertic, you " \
                  "may need to upgrade your OpenSSL version. To check, try running " \
                  "`openssl s_client -connect api.otpsecure.net:443` from the command " \
                  "line."

                when Faraday::TimeoutError
                  "Could not connect to Ecertic (#{ Ecertic.api_base}). " \
                  "Please check your internet connection and try again."

                else
                  "Unexpected error communicating with Ecertic."
                end
      raise APIConnectionError, message + "\n\n(Network error: #{error.message})"
    end

    private def handle_error_response(http_response)
      begin
        response = Ecertic::Response.new(http_response)
      rescue JSON::ParserError
        raise general_api_error(http_response[:status], http_response[:body])
      end

      raise specific_api_error(response)
    end

    private def general_api_error(status, body)
      APIError.new("Invalid response object from API: #{body.inspect} " \
                   "(HTTP response code was #{status})",
                   http_status: status, http_body: body)
    end

    private def specific_api_error(response)
      Ecertic::Utils.log_error("Ecertic API error", status: response.status)

      error = case response.status
              when 400, 404
                InvalidRequestError
              when 401
                AuthenticationError
              else
                APIError
              end
      error.new(response.body, response: response)
    end

    private def base_options
      {
        headers: {
          "Accept" => "application/json",
          "User-Agent" => format_user_agent,
        },
      }
    end

    private def request_options(method, options = {}, data = nil)
      base_options.tap do |options|
        add_body!(options, data) if data
        add_auth_options!(method, options, data) if data
      end
    end

    private def add_body!(options, data)
      options[:headers]["Content-Type"] = content_type(options[:headers])
      options[:body] = content_data(options[:headers], data)
    end

    private def add_auth_options!(method, options, data)
      timestamp = (Time.now.to_f * 1000).to_i.to_s
      hmac = hmac(method, timestamp, options[:body], options[:headers]["Content-Type"])
      options[:headers]["Date"] = timestamp
      options[:headers]["Authorization"] = "Hmac #{apikey}:#{hmac}"
    end

    private def hmac(method, timestamp, data, content_type)
      md5 = Digest::MD5.hexdigest(data)
      signature = "#{method.upcase}\n#{md5}\n#{content_type}\n#{timestamp}"
      OpenSSL::HMAC.hexdigest("SHA1", secret, signature)
    end

    private def format_user_agent
      if user_agent.to_s.empty?
        Ecertic::Default::USER_AGENT
      else
        "#{Ecertic::Default::USER_AGENT} #{user_agent}"
      end
    end

    private def content_type(headers)
      headers["Content-Type"] || "application/json"
    end

    private def content_data(headers, data)
      headers["Content-Type"] == "application/json" ? data.to_json : data
    end

    private def log_request(method, path, body, headers)
      Ecertic::Utils.log_info("Request to Ecertic API", method: method, path: path)
      Ecertic::Utils.log_debug("Request details", body: body, headers: headers)
    end

    private def log_response(request_start, method, path, status, body)
      Ecertic::Utils.log_info("Response from Ecertic API",
                              elapsed: Time.now - request_start,
                              method: method,
                              path: path,
                              status: status)
      Ecertic::Utils.log_debug("Response details", body: body)
    end

    private def log_response_error(request_start, error, method, path)
      Ecertic::Utils.log_error("Request error",
                               elapsed: Time.now - request_start,
                               error_message: error.message,
                               method: method,
                               path: path)
    end
  end
end
