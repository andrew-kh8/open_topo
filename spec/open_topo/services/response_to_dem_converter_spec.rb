# frozen_string_literal: true

require "fileutils"
require "tempfile"
require "timecop"
require "tmpdir"

RSpec.describe OpenTopo::Services::ResponseToDemConverter do
  describe ".call" do
    subject(:dem_file) { described_class.call(response, dem_type:, output_format:, configuration:) }

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
    let(:configuration) { OpenTopo::Configuration.new }

    after do
      file = dem_file.file
      FileUtils.rm_f(file.path) if file
    rescue OpenTopo::Errors::FileError
      nil
    end

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

      around do |example|
        Timecop.freeze(2026, 8, 15, 21, 56, 0) { example.run }
      end

      it "generates a default filename" do
        expect(dem_file.file.path).to eq File.join(File.expand_path(OpenTopo::Configuration::DEFAULT_FILE_DIR), "dem_2026-08-15-21-56-00.tif")
      end
    end

    context "when a custom file directory is configured" do
      let(:configuration) { OpenTopo.configuration }
      let(:file_dir) { Dir.mktmpdir("open_topo-spec") }
      let(:filename) { "custom_filename" }

      before { OpenTopo.configure { |config| config.file_dir = file_dir } }

      after do
        OpenTopo.reset_configuration!
        FileUtils.remove_entry(file_dir) if File.exist?(file_dir)
      end

      it "saves the file in the configured directory" do
        expect(dem_file.file.path).to eq File.join(File.expand_path(file_dir), "custom_filename.tif")
      end
    end

    context "when the file directory cannot be created" do
      let(:parent_file) { Tempfile.new("open_topo-file") }
      let(:configuration) { OpenTopo::Configuration.new(file_dir: File.join(parent_file.path, "nested")) }

      after { parent_file.close! }

      it "raises a FileError" do
        expect { dem_file }.to raise_error(OpenTopo::Errors::FileError)
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
