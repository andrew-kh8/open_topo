# frozen_string_literal: true

RSpec.describe OpenTopo::Client do
  let(:instance) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  describe "#globaldem" do
    context "with valid parameters" do
      let(:globaldem) { instance.globaldem(south: 42.45580075467154, north: 42.45911160123194, west: 25.526535836979747, east: 25.53120849654078) }

      after { File.delete(globaldem.file) if File.exist?(globaldem.file) }

      it "returns a DEM file" do
        VCR.use_cassette("globaldem/success_request") do
          expect(globaldem).to be_a(OpenTopo::DemFile)
        end
      end
    end

    context "with invalid parameters" do
      context "when the parameters are validated with failure" do
        let(:globaldem) { instance.globaldem(south: 42.455, north: 42.459, west: 25.52, east: 25.52) }
        let(:error_message) { "Invalid parameters: west must be less than east (25.52)" }

        it "raises an error" do
          expect { globaldem }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
        end
      end

      context "when request fails" do
        let(:globaldem) { instance.globaldem(south: -42.45580075467154, north: 42.45911160123194, west: -25.526535836979747, east: 25.53120849654078) }
        let(:error_message) do
          "Error: The maximum area for SRTMGL3 is 4,050,000 km2. The selected area is 50,526,423 km2."
        end

        it "raises an error" do
          VCR.use_cassette("globaldem/failure_large_area") do
            expect { globaldem }.to raise_error(OpenTopo::Errors::ResponseError, error_message)
          end
        end
      end
    end
  end

  describe "#usgsdem" do
    context "with valid parameters" do
      let(:usgsdem) { instance.usgsdem(south: 40.4898, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }

      after { File.delete(usgsdem.file) if File.exist?(usgsdem.file) }

      it "returns a DEM file" do
        VCR.use_cassette("usgsdem/success_request") do
          expect(usgsdem).to be_a(OpenTopo::DemFile)
        end
      end
    end

    context "with invalid parameters" do
      context "when the parameters are validated with failure" do
        let(:usgsdem) { instance.usgsdem(south: 40.49, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }
        let(:error_message) { "Invalid parameters: south must be less than north (40.49)" }

        it "raises an error" do
          expect { usgsdem }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
        end
      end

      context "when request returns 204" do
        let(:usgsdem) { instance.usgsdem(south: -25.52, north: 25.52, west: -42.45, east: 42.45, dataset_name: :usgs30m) }

        it "raises an error" do
          VCR.use_cassette("usgsdem/failure_no_data") do
            expect(usgsdem.file).to be_nil
          end
        end
      end

      context "when request fails" do
        let(:usgsdem) { instance.usgsdem(south: 40.489999, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }
        let(:error_message) do
          "Error: The selected area is too small: 0 km2."
        end

        it "raises an error" do
          VCR.use_cassette("usgsdem/failure_small_area") do
            expect { usgsdem }.to raise_error(OpenTopo::Errors::ResponseError, error_message)
          end
        end
      end
    end
  end
end
