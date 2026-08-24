# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class ElevationParams < BaseParams
        DATASETS = {
          anadem: "ANADEM",                       # (DTM 30m)
          arctic_dem10m: "ArcticDEM10m",
          arctic_dem2m: "ArcticDEM2m",
          arctic_dem32m: "ArcticDEM32m",
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
          linz1m_dsm: "LINZ1m_DSM",
          linz1m_dtm: "LINZ1m_DTM",
          nasadem: "NASADEM",                     # (NASADEM Global DEM)
          rema10m: "REMA10m",
          rema2m: "REMA2m",
          rema32m: "REMA32m",
          srtm15_plus: "SRTM15Plus",              # (Global Bathymetry SRTM15+ V2.1 500m)
          srtmgl1_e: "SRTM_GL1_Ellip",            # (SRTM GL1 Ellipsoidal 30m)
          srtmgl1: "SRTM_GL1",                    # (SRTM GL1 30m)
          srtmgl3: "SRTM_GL3",                    # (SRTM GL3 90m)
          usgs10m: "USGS10m",
          usgs30m: "USGS30m"
        }

        validate_with Contracts::ElevationContract

        attr_reader :long, :lat, :dataset

        def initialize(long:, lat:, dataset: :cop30)
          @long = long
          @lat = lat
          @dataset = dataset

          super()
        end

        def to_params
          {
            longitude: long,
            latitude: lat,
            dataset: DATASETS[dataset.to_sym]
          }
        end
      end
    end
  end
end
