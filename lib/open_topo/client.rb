# frozen_string_literal: true

module OpenTopo
  class Client
    API_KEY_NAME = "OPEN_TOPOGRAPHY_API_KEY"

    attr_reader :configuration

    def initialize(
      api_key = nil,
      file_dir: nil,
      global_dataset: nil,
      usgs_dataset: nil,
      elevation_dataset: nil,
      output_format: nil
    )
      api_key ||= ENV.fetch(API_KEY_NAME)
      @configuration = OpenTopo.configuration.dup
      @configuration.update(
        file_dir:,
        global_dataset:,
        usgs_dataset:,
        elevation_dataset:,
        output_format:
      )
      @request = Net::Request.new(api_key)
    end

    def globaldem(south:, north:, west:, east:, dataset: configuration.global_dataset, output_format: configuration.output_format)
      params = Net::Params::GlobaldemParams.new(south:, north:, west:, east:, demtype: dataset, output_format:)
      params.validate!

      response = request.globaldem(params)

      if response.success?
        Services::ResponseToDemConverter.new(configuration).call(response, dem_type: dataset, output_format:)
      else
        raise ::OpenTopo::Errors::ResponseError, response.body
      end
    end

    def usgsdem(south:, north:, west:, east:, dataset_name: configuration.usgs_dataset, output_format: configuration.output_format)
      params = Net::Params::UsgsdemParams.new(south:, north:, west:, east:, dataset_name:, output_format:)
      params.validate!

      response = request.usgsdem(params)

      if response.success?
        Services::ResponseToDemConverter.new(configuration).call(response, dem_type: dataset_name, output_format:)
      else
        raise ::OpenTopo::Errors::ResponseError, response.body
      end
    end

    def elevation(long:, lat:, dataset: configuration.elevation_dataset)
      params = Net::Params::ElevationParams.new(long:, lat:, dataset:)
      params.validate!

      response = request.elevation(params)

      if response.success?
        Services::ResponseToPointConverter.call(response)
      else
        raise ::OpenTopo::Errors::ResponseError, response.body
      end
    end

    def catalog(west: nil, south: nil, east: nil, north: nil, polygon: nil)
      params = Net::Params::CatalogParams.new(west:, south:, east:, north:, polygon:)
      params.validate!

      response = request.catalog(params)

      if response.success?
        Services::ResponseToCatalogListConverter.call(response.body)
      else
        raise ::OpenTopo::Errors::ResponseError, response.body
      end
    end

    private

    attr_reader :request
  end
end
