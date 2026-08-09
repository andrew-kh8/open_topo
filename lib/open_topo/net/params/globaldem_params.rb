# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class GlobaldemParams
        OUTPUT_FORMATS = {tif: "GTiff", hfa: "HFA", asc: "AAIGrid"}
        DEM_TYPES = {
          anadem: "ANADEM",                       # (DTM 30m)
          aw3_d30_e: "AW3D30_E",                  # (ALOS World 3D Ellipsoidal, 30m)
          aw3_d30: "AW3D30",                      # (ALOS World 3D 30m)
          ca_mrdem_dsm: "CA_MRDEM_DSM",           # (DSM 30m)
          ca_mrdem_dtm: "CA_MRDEM_DTM",           # (DTM 30m)
          cop30: "COP30",                         # (Copernicus Global DSM 30m)
          cop90: "COP90",                         # (Copernicus Global DSM 90m)
          eu_dtm: "EU_DTM",                       # (DTM 30m)
          gebco_ice_topo: "GEBCOIceTopo",         # (Global Bathymetry 500m)
          gebco_sub_ice_topo: "GEBCOSubIceTopo",  # (Global Bathymetry 500m)
          gedi_l3: "GEDI_L3",                     # (DTM 1000m)
          gedtm30: "GEDTM30",                     # (DTM 30m)
          nasadem: "NASADEM",                     # (NASADEM Global DEM)
          srtm15_plus: "SRTM15Plus",              # (Global Bathymetry SRTM15+ V2.1 500m)
          srtmgl1_e: "SRTMGL1_E",                 # (SRTM GL1 Ellipsoidal 30m)
          srtmgl1: "SRTMGL1",                     # (SRTM GL1 30m)
          srtmgl3: "SRTMGL3"                      # (SRTM GL3 90m)
        }

        attr_reader :south, :north, :west, :east, :demtype, :output_format

        def initialize(south:, north:, west:, east:, demtype:, output_format:)
          @south = south
          @north = north
          @west = west
          @east = east
          @demtype = demtype
          @output_format = output_format
          @validation_result = nil
        end

        def to_params
          {
            south:,
            north:,
            west:,
            east:,
            demtype: DEM_TYPES[demtype.to_sym],
            outputFormat: OUTPUT_FORMATS[output_format.to_sym]
          }
        end
        alias_method :to_h, :to_params

        def valid?
          validate
          validation_result.success?
        end

        def validate!
          if !valid?
            raise ::OpenTopo::Errors::ParamsError, "Invalid parameters: #{error_messages.join(", ")}"
          end
        end

        def error_messages
          if !validation_result.nil? && validation_result.failure?
            validation_result.errors(full: true).messages.map(&:text)
          else
            []
          end
        end

        private

        attr_reader :validation_result

        def validate
          @validation_result = Contracts::GlobaldemContract.new.call(to_params)
        end
      end
    end
  end
end
