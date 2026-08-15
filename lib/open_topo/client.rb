# frozen_string_literal: true

module OpenTopo
  class Client
    API_KEY_NAME = "OPEN_TOPOGRAPHY_API_KEY"

    def initialize(api_key = nil)
      api_key ||= ENV.fetch(API_KEY_NAME)
      @request = Net::Request.new(api_key)
    end

    def globaldem(south:, north:, west:, east:, demtype: :srtmgl3, output_format: :tif)
      params = Net::Params::GlobaldemParams.new(south:, north:, west:, east:, demtype:, output_format:)
      params.validate!

      response = @request.globaldem(params)

      if response.success?
        Services::ResponseToDemConverter.call(response, dem_type: demtype, output_format:)
      else
        raise ::OpenTopo::Errors::ResponseError, response.body
      end
    end
  end
end
