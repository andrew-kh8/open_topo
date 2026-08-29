# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "oj"

module OpenTopo
  module Net
    class Connection
      def initialize(api_key = nil)
        @api_key = api_key
      end

      def build
        create_connection
      end

      private

      BASE_URL = "https://portal.opentopography.org"
      XML_CONTENT_TYPE = "application/xml"
      ACCEPT_CONTENT_TYPE = "application/octet-stream,application/json,#{XML_CONTENT_TYPE}"

      attr_reader :api_key

      def create_connection
        Faraday.new(options, request: request_options) do |faraday|
          faraday.request :url_encoded
          faraday.response :logger
          faraday.response :xml, content_type: XML_CONTENT_TYPE
          faraday.response :json, parser_options: {decoder: Oj, symbolize_names: true}
          faraday.adapter Faraday.default_adapter
        end
      end

      def options
        {
          url: BASE_URL,
          headers: headers,
          params: {API_Key: api_key}
        }
      end

      def headers
        {
          "Accept" => ACCEPT_CONTENT_TYPE,
          "User-Agent" => "Ruby open_topo v#{OpenTopo::VERSION}"
        }
      end

      def request_options
        {
          # timeout: 7 # it creates tif file, so it can be slow :(
        }
      end
    end
  end
end
