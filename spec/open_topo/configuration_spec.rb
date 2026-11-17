# frozen_string_literal: true

require "pathname"

RSpec.describe OpenTopo::Configuration do
  subject(:configuration) { described_class.new }

  describe "#defaults" do
    it "uses the client defaults" do
      expect(configuration.global_dataset).to eq :srtmgl3
      expect(configuration.usgs_dataset).to eq :usgs10m
      expect(configuration.elevation_dataset).to eq :srtmgl3
      expect(configuration.output_format).to eq :tif
    end

    context "with overrides" do
      subject(:configuration) do
        described_class.new(
          global_dataset: :cop30,
          usgs_dataset: :usgs30m,
          elevation_dataset: :cop30,
          output_format: :asc
        )
      end

      it "uses the overridden values" do
        expect(configuration.global_dataset).to eq :cop30
        expect(configuration.usgs_dataset).to eq :usgs30m
        expect(configuration.elevation_dataset).to eq :cop30
        expect(configuration.output_format).to eq :asc
      end
    end
  end

  describe "#file_dir" do
    it "defaults to the expanded default directory" do
      expect(configuration.file_dir).to eq File.expand_path(OpenTopo::Configuration::DEFAULT_FILE_DIR)
    end

    it "expands relative paths" do
      configuration.file_dir = "./custom_dem_files"

      expect(configuration.file_dir).to eq File.expand_path("./custom_dem_files")
    end

    it "expands home paths" do
      configuration.file_dir = "~/custom_dem_files"

      expect(configuration.file_dir).to eq File.expand_path("~/custom_dem_files")
    end

    it "accepts a path-like object" do
      configuration.file_dir = Pathname("./custom_dem_files")

      expect(configuration.file_dir).to eq File.expand_path("./custom_dem_files")
    end
  end

  describe "#file_dir=" do
    it "raises FileError for nil" do
      expect { configuration.file_dir = nil }.to raise_error(OpenTopo::Errors::FileError, "file_dir must be a path")
    end

    it "raises FileError for an empty string" do
      expect { configuration.file_dir = "" }.to raise_error(OpenTopo::Errors::FileError, "file_dir must not be empty")
    end

    it "raises FileError when the path is not a directory" do
      expect { configuration.file_dir = __FILE__ }.to raise_error(OpenTopo::Errors::FileError, "file_dir must be a directory")
    end

    it "wraps path errors in FileError" do
      expect { configuration.file_dir = "bad\0path" }.to raise_error(OpenTopo::Errors::FileError)
    end
  end
end
