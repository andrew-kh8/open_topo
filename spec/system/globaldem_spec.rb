# frozen_string_literal: true

RSpec.describe "Global dem system specs" do
  let(:client) { OpenTopo::Client.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  context "happy path" do
    let(:globaldem) { client.globaldem(south: 42.45580075467154, north: 42.45911160123194, west: 25.526535836979747, east: 25.53120849654078) }
    let(:tif_file) { globaldem.file }
    let(:csv_file) { globaldem.convert_to(:csv) }

    after do
      File.delete(tif_file)
      File.delete(csv_file)
    end

    it "returns a DEM file" do
      VCR.use_cassette("globaldem/success_request") do
        expect(globaldem).to be_a(OpenTopo::DemFile)

        expect(tif_file).to be_a(File)
        expect(csv_file).to be_a(File)

        expect(FileUtils.compare_file(File.open("spec/fixtures/files/global_csv.csv"), csv_file)).to eq true
      end
    end
  end

  context "unhappy path" do
    let(:globaldem) { client.globaldem(south: -42.45580075467154, north: 42.45911160123194, west: -25.526535836979747, east: 25.53120849654078) }

    it "raises an error" do
      VCR.use_cassette("globaldem/failure_large_area") do
        expect { globaldem }.to raise_error(
          OpenTopo::Errors::ResponseError,
          "Error: The maximum area for SRTMGL3 is 4,050,000 km2. The selected area is 50,526,423 km2."
        )
      end
    end
  end
end
