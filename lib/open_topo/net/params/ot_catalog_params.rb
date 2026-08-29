# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class OtCatalogParams < BaseParams
        PRODUCT_FORMATS = {point_cloud: "PointCloud", raster: "Raster"}

        validate_with Contracts::OtCatalogContract

        attr_reader :product_format, :west, :south, :east, :north, :polygon

        def initialize(product_format: nil, west: nil, south: nil, east: nil, north: nil, polygon: nil)
          @product_format = product_format # ???
          @west = west
          @south = south
          @east = east
          @north = north
          @polygon = polygon

          super()
        end

        def to_params
          params = {
            outputFormat: "xml",
            detail: false,
            include_federated: false
          }

          if product_format
            params[:productFormat] = PRODUCT_FORMATS[product_format.to_sym]
          end

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
      end
    end
  end
end
