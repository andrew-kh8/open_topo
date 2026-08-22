# frozen_string_literal: true

RSpec.describe OpenTopo::Errors::FileError do
  context "default error examples" do
    include_examples "error_examples"
  end

  describe "#file" do
    subject { instance.file }

    let(:instance) { described_class.new("message", file_path:) }

    context "when file path is nil" do
      let(:file_path) { nil }
      it { is_expected.to be_nil }
    end

    context "when file path is a fake path" do
      let(:file_path) { "fake/path" }
      it { is_expected.to be_nil }
    end

    context "when file path is a real path" do
      let(:file_path) { "spec/fixtures/files/test_tif.tif" }
      it { expect(FileUtils.compare_file(File.open(file_path), subject)).to eq true }
    end
  end
end
