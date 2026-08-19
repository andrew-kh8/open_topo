# frozen_string_literal: true

RSpec.describe OpenTopo::Client do
  let(:instance) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  describe "#globaldem" do
    let(:globaldem) { instance.globaldem(south: 25.526535836979747, north: 25.53120849654078, west: 42.45580075467154, east: 42.45911160123194) }

    context "with valid parameters" do
      it "returns a DEM file" do
        VCR.use_cassette("globaldem/success_request") do
          expect(globaldem).to be_a(OpenTopo::DemFile)
        end
      end
    end

    context "with invalid parameters" do
      context "when the parameters are validated with failure" do
        let(:globaldem) { instance.globaldem(south: 25.52, north: 25.52, west: 42.455, east: 42.459) }
        let(:error_message) { "Invalid parameters: south must be less than north (25.52)" }

        it "raises an error" do
          expect { globaldem }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
        end
      end

      context "when request fails" do
        let(:globaldem) { instance.globaldem(south: -25.52, north: 25.52, west: -42.45, east: 42.45) }
        let(:error_message) do
          "Error: The maximum area for SRTMGL3 is 4,050,000 km2. The selected area is 60,801,614 km2."
        end

        it "raises an error" do
          VCR.use_cassette("globaldem/failure_large_area") do
            expect { globaldem }.to raise_error(OpenTopo::Errors::ResponseError, error_message)
          end
        end
      end
    end
  end
end
