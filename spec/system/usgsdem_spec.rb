# frozen_string_literal: true

RSpec.describe "USGS dem system specs" do
  let(:client) { OpenTopo::Client.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  context "happy path" do
    let(:usgsdem) { client.usgsdem(south: 40.4898, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }
    let(:tif_file) { usgsdem.file }
    let(:csv_file) { usgsdem.convert_to(:csv) }

    after do
      File.delete(tif_file)
      File.delete(csv_file)
    end

    it "returns a DEM file" do
      VCR.use_cassette("usgsdem/success_request") do
        expect(usgsdem).to be_a(OpenTopo::DemFile)

        expect(tif_file).to be_a(File)
        expect(csv_file).to be_a(File)

        expect(FileUtils.compare_file(File.open("spec/fixtures/files/usgs_csv.csv"), csv_file)).to eq true
      end
    end
  end

  context "unhappy path" do
    let(:usgsdem) { client.usgsdem(south: -25.52, north: 25.52, west: -42.45, east: 42.45, dataset_name: :usgs30m) }

    it "raises an error" do
      VCR.use_cassette("usgsdem/failure_no_data") do
        expect(usgsdem.file).to be_nil

        expect { usgsdem.convert_to(:csv) }.to raise_error(OpenTopo::Errors::FileError, "File is not a file (NilClass)")
      end
    end
  end
end
