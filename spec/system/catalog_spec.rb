# frozen_string_literal: true

RSpec.describe "Catalog system specs" do
  let(:client) { OpenTopo::Client.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  context "with 4 coords params" do
    let(:catalogs) { client.catalog(north:, south:, west:, east:) }
    let(:north) { 84.5 }
    let(:south) { 84 }
    let(:west) { 121 }
    let(:east) { 121.5 }

    it "returns an array of Catalog" do
      VCR.use_cassette("catalog/success") do
        expect(catalogs).to be_a(Array)

        expect(catalogs.size).to eq 3
        expect(catalogs[0]).to be_a(OpenTopo::Catalog)
      end
    end

    context "when param is invalid" do
      let(:east) { west }

      it "raises an error" do
        expect { catalogs }.to raise_error(
          OpenTopo::Errors::ParamsError,
          "Invalid parameters: west must be less than east (121.0)"
        )
      end
    end

    context "when there is no data" do
      let(:north) { 89.5 }
      let(:south) { 89 }

      it "raises an error" do # check and upd
        VCR.use_cassette("catalog/success_no_data") do
          expect(catalogs).to be_a(Array)

          expect(catalogs.size).to eq 0
        end
      end
    end
  end

  context "with polygon params" do
    let(:catalogs) { client.catalog(polygon:) }

    context "with valid polygon" do
      let(:polygon) { "-117.5,32.5,-117.5,33.1,-116.7,33.1,-116.7,32.5,-117.0,32.3,-117.5,32.5" }

      it "returns array of Catalog" do
        VCR.use_cassette("catalog/polygon_success") do
          expect(catalogs).to be_a(Array)
          expect(catalogs.size).to eq 13
        end
      end
    end

    context "with invalid polygon" do
      let(:polygon) { "-117.5,32.5,-117.0,32.3,-117.5,32.5" }

      it "returns array of Catalog" do
        VCR.use_cassette("catalog/polygon_failure") do
          expect { catalogs }.to raise_error(
            OpenTopo::Errors::ResponseError,
            "Error: Invalid geometry format: -117.5,32.5,-117.0,32.3,-117.5,32.5"
          )
        end
      end
    end
  end
end
