# frozen_string_literal: true

module OpenTopo
  module Net
    class Request
      GLOBALDEM_ENDPOINT = "/API/globaldem"
      USGSDEM_ENDPOINT = "/API/usgsdem"

      def initialize(api_key = nil)
        @connection = Connection.new(api_key).build
      end

      def globaldem(params)
        Response.new(@connection.get(GLOBALDEM_ENDPOINT, params.to_params))
      end

      def usgsdem(params)
        Response.new(@connection.get(USGSDEM_ENDPOINT, params.to_params))
      end
    end
  end
end
