RSpec.describe OpenTopo::Services::DemConverter do
  describe ".call" do
    subject { described_class.call(file, file_format, file_path:) }

    let(:file) { File.open("spec/fixtures/files/global_tif.tif") }
    let(:file_format) { :csv }
    let(:file_path) { "spec/fixtures/files/global_tif.csv" }

    after { File.delete(file_path) if File.exist?(file_path) }

    it "convert tif to csv" do
      expect(subject.path).to eq file_path
    end

    it "fills correct data" do
      expect(FileUtils.compare_file(File.open("spec/fixtures/files/global_csv.csv"), subject)).to eq true
    end

    context "when file is not a File" do
      let(:file) { "" }

      it "raises an exception" do
        expect { subject }.to raise_error(OpenTopo::Errors::FileError, "File is not a file (String)")
      end
    end

    context "when file is not supported by gdal" do
      let(:file) { Tempfile.new("fake_file") }

      it "raises an exception" do
        expect { subject }.to raise_error(OpenTopo::Errors::ConvertError, "ERROR 4: `#{file.path}' not recognized as a supported file format.")
      end
    end
  end

  describe ".build_new_filename" do
    subject(:result) { described_class.send(:build_new_filename, file, file_path, file_format) }

    let(:file_path) { "./spec" }
    let(:file_format) { :csv }
    let(:file) { File.new("spec/fixtures/files/global_tif.tif") }

    context "when file_path is a directory" do
      it "returns a path inside the directory with correct extension" do
        expect(result).to eq("./spec/global_tif.csv")
      end
    end

    context "when file_path is a directory with slash" do
      let(:file_path) { "./spec/" }

      it "adds the extension to the provided file name" do
        expect(result).to eq("./spec/global_tif.csv")
      end
    end

    context "when file_path is a full file path with extension" do
      let(:file_path) { "./spec/newfile.txt" }

      it "replaces the extension with the new one" do
        expect(result).to eq(file_path)
      end
    end

    context "when file_path is nil" do
      let(:file_path) { nil }

      it "builds filename based on the file object" do
        expect(result).to eq("spec/fixtures/files/global_tif.csv")
      end
    end

    context "when file_format is a string" do
      let(:file_format) { "json" }

      it "uses the provided string extension" do
        expect(result).to eq("./spec/global_tif.json")
      end
    end

    context "when file_format is nil" do
      let(:file_format) { nil }

      it "keeps original extension from file_path" do
        expect(result).to eq("./spec/global_tif.")
      end
    end

    context "when file_path is an empty string" do
      let(:file_path) { "" }
      let(:file_format) { :csv }

      it "falls back to file-based name" do
        expect(result).to eq("spec/fixtures/files/global_tif.csv")
      end
    end

    context "when file_path points to a non-existing directory" do
      let(:file_path) { "./nonexistent_dir" }
      let(:file_format) { :csv }

      it "still returns a valid filename string" do
        expect { result }.to raise_error(OpenTopo::Errors::FileError, "No such file or directory")
      end
    end
  end
end
