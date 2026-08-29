# frozen_string_literal: true

RSpec.describe "Elevation point system specs" do
  let(:client) { OpenTopo::Client.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  context "happy path" do
    let(:elevation) { client.elevation(long:, lat:) }
    let(:long) { -1.6028 }
    let(:lat) { 51.0176 }

    it "returns a Point object" do
      VCR.use_cassette("elevation/success_request") do
        expect(elevation).to be_a(OpenTopo::Point)

        expect(elevation.long).to eq long
        expect(elevation.lat).to eq lat
        expect(elevation.heigh).to eq 93.0
        expect(elevation.unit).to eq "Meters"
      end
    end
  end

  context "unhappy path" do
    let(:elevation) { client.elevation(long:, lat:) }

    context "when param is invalid" do
      let(:long) { 200 }
      let(:lat) { 51.0176 }

      it "raises an error" do
        expect { elevation }.to raise_error(
          OpenTopo::Errors::ParamsError,
          "Invalid parameters: longitude must be less than or equal to 180"
        )
      end
    end

    context "when there is no point data" do
      let(:long) { -150 }
      let(:lat) { 50 }

      it "raises an error" do
        VCR.use_cassette("elevation/failure_no_data") do
          expect { elevation }.to raise_error(
            OpenTopo::Errors::ResponseError,
            "Not found"
          )
        end
      end
    end
  end
end
