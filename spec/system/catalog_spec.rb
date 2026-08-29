# frozen_string_literal: true

RSpec.describe "Catalog system specs" do
  let(:client) { OpenTopo::Client.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  context "with 4 coords params" do
    let(:catalogs) { client.catalog(north:, south:, west:, east:) }
    let(:north) { 84.5 }
    let(:south) { 84 }
    let(:west) { 121 }
    let(:east) { 121.5 }

    it "returns a Point object" do
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
          "Invalid parameters: south must be less than maxx (121.0)"
        )
      end
    end

    context "when there is no point data" do
      let(:north) { 89.5 }
      let(:south) { 89 }

      it "raises an error" do
        VCR.use_cassette("catalog/success_no_data") do
          expect(catalogs).to be_a(Array)

          expect(catalogs.size).to eq 0
        end
      end
    end
  end
end
