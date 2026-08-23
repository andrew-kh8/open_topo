# frozen_string_literal: true

RSpec.describe OpenTopo::DemFile do
  let(:instance) { described_class.new(original_file:, dem_type: :srtmgl3, output_format: :tif) }
  let(:original_file) { File.open("spec/fixtures/files/test_tif.tif", "r") }

  describe "#convert_to" do
    subject { instance.convert_to(format, file_path:) }

    let(:format) { :csv }
    let(:file_path) { "file/path" }
    let(:convert_result) { double }

    it "executes a converter" do
      expect(OpenTopo::Services::DemConverter).to receive(:call).with(original_file, format, file_path:)
        .and_return(convert_result)

      expect(subject).to eq convert_result
    end
  end
end
