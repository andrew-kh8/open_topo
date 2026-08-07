# frozen_string_literal: true

module OpenTopo
  module Net
    class Request
      OUTPUT_FORMATS = {tif: "GTiff", hfs: "HFA", asc: "AAIGrid"}

      def initialize(api_key = nil)
        @connection = Connection.new(api_key).build
      end

      def globaldem(south:, north:, west:, east:, demtype:, output_format:)
        params = {
          demtype:,
          south:,
          north:,
          west:,
          east:,
          outputFormat: OUTPUT_FORMATS[output_format]
        }

        @connection.get("/API/globaldem", params)
      end
    end
  end
end
