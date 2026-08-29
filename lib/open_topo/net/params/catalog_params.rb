# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class CatalogParams < BaseParams
        validate_with Contracts::CatalogContract

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
            params[:maxx] = east
            params[:minx] = west

            params[:maxy] = north
            params[:miny] = south
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
