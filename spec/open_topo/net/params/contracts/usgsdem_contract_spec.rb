# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::Contracts::UsgsdemContract do
  subject(:validation_result) { described_class.new.call(globaldem_params) }

  let(:globaldem_params) do
    {
      south:,
      north:,
      west:,
      east:,
      datasetName: dataset_name,
      outputFormat: output_format
    }
  end

  let(:south) { -10.0 }
  let(:north) { 10.0 }
  let(:west) { -20.0 }
  let(:east) { 20.0 }
  let(:dataset_name) { "USGS30m" }
  let(:output_format) { "GTiff" }

  describe "parameters validation" do
    include_examples "Coordinates comparable with no include"

    context "when all parameters are valid" do
      it "is successful" do
        expect(validation_result).to be_success
        expect(validation_result.errors.to_h).to be_empty
      end
    end

    context "when dataset name is invalid" do
      let(:dataset_name) { "invalid" }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({datasetName: ["must be a valid DEM type"]})
      end
    end

    context "when output_format is invalid" do
      let(:output_format) { "invalid" }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({outputFormat: ["must be a valid output format"]})
      end
    end
  end
end
