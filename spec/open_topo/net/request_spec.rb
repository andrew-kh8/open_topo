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

  describe "#usgsdem" do
    subject(:usgsdem) { instance.usgsdem(params) }

    context "with valid parameters" do
      let(:params) { build(:usgsdem_params) }

      it "returns a Response object" do
        VCR.use_cassette("usgsdem/success_request") do
          expect(usgsdem).to be_a(OpenTopo::Net::Response)
          expect(usgsdem.status).to eq 200
          expect(usgsdem.body).to be_a(String)
        end
      end
    end

    context "with invalid parameters" do
      let(:params) { build(:usgsdem_params, south: 40.489999) }

      it "returns a Response object" do
        VCR.use_cassette("usgsdem/failure_small_area") do
          expect(usgsdem).to be_a(OpenTopo::Net::Response)
          expect(usgsdem.status).to eq 400
          expect(usgsdem.body).to be_a(Hash)
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

  describe "#catalog" do
    subject(:catalog) { instance.catalog(params) }

    context "with 4 coords params" do
      let(:params) { build(:catalog_params, west:, south:, east:, north:) }
      let(:north) { 84.5 }
      let(:south) { 84 }
      let(:west) { 121 }
      let(:east) { 121.5 }

      it "returns an array of Catalog" do
        VCR.use_cassette("catalog/success") do
          expect(catalog).to be_a(OpenTopo::Net::Response)
          expect(catalog.status).to eq 200
          expect(catalog.body).to be_a(Hash)
        end
      end

      context "when param is invalid" do
        let(:east) { west }

        it "raises an error" do
          VCR.use_cassette("catalog/failure_invalid_params") do
            expect(catalog).to be_a(OpenTopo::Net::Response)
            expect(catalog.status).to eq 400
            expect(catalog.body).to be_a(Hash)
          end
        end
      end

      context "when there is no data" do
        let(:north) { 89.5 }
        let(:south) { 89 }

        it "returns a response" do
          VCR.use_cassette("catalog/success_no_data") do
            expect(catalog).to be_a(OpenTopo::Net::Response)
            expect(catalog.status).to eq 200
            expect(catalog.body).to be_a(Hash)
          end
        end
      end
    end

    context "with polygon params" do
      let(:params) { build(:catalog_params, polygon:) }

      context "with valid polygon" do
        let(:polygon) { "-117.5,32.5,-117.5,33.1,-116.7,33.1,-116.7,32.5,-117.0,32.3,-117.5,32.5" }

        it "returns array of Catalog" do
          VCR.use_cassette("catalog/polygon_success") do
            expect(catalog).to be_a(OpenTopo::Net::Response)
            expect(catalog.status).to eq 200
            expect(catalog.body).to be_a(Hash)
          end
        end
      end

      context "with invalid polygon" do
        let(:polygon) { "-117.5,32.5,-117.0,32.3,-117.5,32.5" }

        it "returns array of Catalog" do
          VCR.use_cassette("catalog/polygon_failure") do
            expect(catalog).to be_a(OpenTopo::Net::Response)
            expect(catalog.status).to eq 400
            expect(catalog.body).to be_a(Hash)
          end
        end
      end
    end
  end
end
