# frozen_string_literal: true

RSpec.describe OpenTopo do
  after { described_class.reset_configuration! }

  describe ".configure" do
    it "sets the file directory" do
      described_class.configure { |config| config.file_dir = "./custom_dem_files" }

      expect(described_class.configuration.file_dir).to eq File.expand_path("./custom_dem_files")
    end
  end

  describe ".reset_configuration!" do
    it "restores the default file directory" do
      described_class.configure { |config| config.file_dir = "./custom_dem_files" }

      described_class.reset_configuration!

      expect(described_class.configuration.file_dir).to eq File.expand_path(OpenTopo::Configuration::DEFAULT_FILE_DIR)
    end
  end

  it "has a version number" do
    expect(OpenTopo::VERSION).not_to be nil
  end
end
