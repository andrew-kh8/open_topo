# frozen_string_literal: true

require "timecop"

RSpec.describe OpenTopo::Services::ResponseToDemConverter do
  describe ".call" do
    subject(:dem_file) { described_class.call(response, dem_type:, output_format:) }

    let(:response) do
      instance_double(
        OpenTopo::Net::Response,
        body: "fake_tif_data",
        data?: data_present,
        headers: instance_double(OpenTopo::Net::Response::Headers, filename:)
      )
    end
    let(:filename) { "fake_filename.tif" }
    let(:output_format) { :tif }
    let(:dem_type) { :srtmgl3 }
    let(:data_present) { true }

    after { File.delete(dem_file.file) if dem_file.file && File.exist?(dem_file.file) }

    context "when response is valid" do
      it "returns a DemFile object with the correct attributes" do
        expect(dem_file).to be_a(OpenTopo::DemFile)
        expect(dem_file.dem_type).to eq(dem_type)
        expect(dem_file.output_format).to eq(output_format)
        expect(dem_file.file).to be_a(File)
        expect(dem_file.file.read).to eq("fake_tif_data")
      end
    end

    context "when response does not have a filename" do
      let(:filename) { nil }

      before { Timecop.freeze(2026, 8, 15, 21, 56, 0) }
      after { Timecop.return }

      it "generates a default filename" do
        expect(dem_file.file.path).to eq "dem_2026-08-15-21-56-00.tif"
      end
    end

    context "when response have a empty body" do
      let(:data_present) { false }

      it "returns a nil" do
        expect(dem_file.file).to be_nil
      end
    end
  end
end
