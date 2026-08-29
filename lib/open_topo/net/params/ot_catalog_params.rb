# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class OtCatalogParams < BaseParams
        validate_with Contracts::OtCatalogContract

        attr_reader :west, :south, :east, :north, :polygon

        def initialize(west: nil, south: nil, east: nil, north: nil, polygon: nil)
          @west = west
          @south = south
          @east = east
          @north = north
          @polygon = polygon

          super()
        end

        def to_params
          params = default_params

          if polygon
            params[:polygon] = polygon
          else
            params[:minx] = west
            params[:miny] = south
            params[:maxx] = east
            params[:maxy] = north
          end

          params
        end

        private

        def default_params
          {
            outputFormat: "xml",
            detail: false,
            include_federated: false,
            productFormat: "Raster"
          }
        end
      end
    end
  end
end
