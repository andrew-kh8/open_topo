# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Request do
  let(:instance) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  describe "#globaldem" do
    subject(:globaldem) { instance.globaldem(params) }

    context "with valid parameters" do
      let(:params) { build(:globaldem_params) }

      it "returns a Response object" do
        VCR.use_cassette("globaldem/success_request") do
          expect(globaldem).to be_a(OpenTopo::Net::Response)
          expect(globaldem.status).to eq 200
          expect(globaldem.body).to be_a(String)
        end
      end
    end

    context "with invalid parameters" do
      let(:params) { build(:globaldem_params, north: 42.459, south: 42.459) }

      it "returns a Response object" do
        VCR.use_cassette("globaldem/failure_request") do
          expect(globaldem).to be_a(OpenTopo::Net::Response)
          expect(globaldem.status).to eq 400
          expect(globaldem.body).to be_a(Hash)
        end
      end
    end
  end

  describe "#elevation" do
    subject(:elevation) { instance.elevation(params) }

    context "with valid parameters" do
      let(:params) { build(:elevation_params) }

      it "returns a Response object" do
        VCR.use_cassette("elevation/success_request") do
          expect(elevation).to be_a(OpenTopo::Net::Response)
          expect(elevation.status).to eq 200
          expect(elevation.body).to be_a(Hash)
        end
      end
    end

    context "with invalid parameters" do
      let(:params) { build(:elevation_params, long: 200) }

      it "returns a Response object" do
        VCR.use_cassette("elevation/failure_request") do
          expect(elevation).to be_a(OpenTopo::Net::Response)
          expect(elevation.status).to eq 400
          expect(elevation.body).to be_a(Hash)
        end
      end
    end
  end
end
