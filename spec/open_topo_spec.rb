# frozen_string_literal: true

RSpec.describe OpenTopo do
  describe ".configure" do
    after { described_class.configuration.file_dir = OpenTopo::DEFAULT_FILE_DIR }

    it "sets the file directory" do
      described_class.configure { |config| config.file_dir = "./custom_dem_files" }

      expect(described_class.configuration.file_dir).to eq("./custom_dem_files")
    end
  end

  it "has a version number" do
    expect(OpenTopo::VERSION).not_to be nil
  end
end
