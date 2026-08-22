# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class UsgsdemParams < BaseParams
        OUTPUT_FORMATS = {tif: "GTiff", hfa: "HFA", asc: "AAIGrid"}
        DEM_TYPES = {
          usgs1m: "USGS1m",
          usgs10m: "USGS10m",
          usgs30m: "USGS30m"
        }

        validate_with Contracts::UsgsdemContract

        attr_reader :south, :north, :west, :east, :demtype, :output_format

        def initialize(south:, north:, west:, east:, dataset_name:, output_format:)
          @south = south
          @north = north
          @west = west
          @east = east
          @demtype = dataset_name
          @output_format = output_format
        end

        def to_params
          {
            south:,
            north:,
            west:,
            east:,
            datasetName: DEM_TYPES[demtype.to_sym],
            outputFormat: OUTPUT_FORMATS[output_format.to_sym]
          }
        end
      end
    end
  end
end
