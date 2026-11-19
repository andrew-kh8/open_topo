# frozen_string_literal: true

require "fileutils"
require "tempfile"
require "timecop"
require "tmpdir"

RSpec.describe OpenTopo::Services::ResponseToDemConverter do
  describe "#call" do
    subject(:dem_file) { converter.call(response, dem_type:, output_format:) }

    let(:converter) { described_class.new(configuration) }
    let(:configuration) { OpenTopo::Configuration.new(file_dir:) }
    let(:file_dir) { Dir.mktmpdir("open_topo-spec") }
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
    let(:file_path) { File.join(file_dir, "#{filename || default_filename}.tif") }
    let(:default_filename) { "dem_2026-08-15-21-56-00" }

    after do
      FileUtils.rm_f(file_path)
      FileUtils.remove_entry(file_dir) if File.exist?(file_dir)
    end

    context "when response is valid" do
      it "returns a DemFile object with the correct attributes" do
        expect(dem_file).to be_a(OpenTopo::DemFile)
        expect(dem_file.dem_type).to eq(dem_type)
        expect(dem_file.output_format).to eq(output_format)
        expect(dem_file.file).to be_a(File)
        expect(dem_file.file.read).to eq("fake_tif_data")
      end

      it "writes the file to the configured directory" do
        expect(dem_file.file.path).to eq(file_path)
      end
    end

    context "when response does not have a filename" do
      let(:filename) { nil }

      around do |example|
        Timecop.freeze(2026, 8, 15, 21, 56, 0) { example.run }
      end

      it "generates a default filename" do
        expect(dem_file.file.path).to eq(file_path)
      end
    end

    context "when the file directory cannot be created" do
      let(:parent_file) { Tempfile.new("open_topo-file") }
      let(:file_dir) { File.join(parent_file.path, "nested") }

      after { parent_file.close! }

      it "raises a FileError" do
        expect { dem_file }.to raise_error(OpenTopo::Errors::FileError)
      end
    end

    context "when response have an empty body" do
      let(:data_present) { false }

      it "returns nil" do
        expect(dem_file.file).to be_nil
      end
    end
  end
end
