# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::UsgsdemParams do
  let(:instance) { described_class.new(south:, north:, west:, east:, dataset_name:, output_format:) }

  let(:south) { -10.0 }
  let(:north) { 10.0 }
  let(:west) { -20.0 }
  let(:east) { 20.0 }
  let(:dataset_name) { :usgs30m }
  let(:output_format) { :tif }

  describe "#to_params, #to_h" do
    let(:expected_params) do
      {
        south: south,
        north: north,
        west: west,
        east: east,
        datasetName: "USGS30m",
        outputFormat: "GTiff"
      }
    end

    it { expect(instance.to_params).to eq(expected_params) }
    it { expect(instance.to_h).to eq(expected_params) }
  end

  describe "#validate!" do
    let(:validator) { instance_double(OpenTopo::Net::Params::Contracts::UsgsdemContract) }
    let(:validation_result) { double(success?: true) }

    it "calls elevation contract" do
      expect(OpenTopo::Net::Params::Contracts::UsgsdemContract).to receive(:new).and_return(validator)
      expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

      expect(instance.validate!).to eq true
    end
  end

  describe "#valid?" do
    let(:validator) { instance_double(OpenTopo::Net::Params::Contracts::UsgsdemContract) }
    let(:validation_result) { double(success?: true) }

    it "calls elevation contract" do
      expect(OpenTopo::Net::Params::Contracts::UsgsdemContract).to receive(:new).and_return(validator)
      expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

      expect(instance.valid?).to eq true
    end
  end

  xdescribe "#error_messages" # TODO: rewrite with less dependency
end
