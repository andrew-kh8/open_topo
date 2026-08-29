# frozen_string_literal: true

module OpenTopo
  module Services
    class ResponseToPointConverter
      def self.call(response)
        Point.new(
          long: response.body[:Location][:Longitude],
          lat: response.body[:Location][:Latitude],
          heigh: response.body[:Elevation],
          unit: response.body[:Unit]
        )
      end
    end
  end
end
