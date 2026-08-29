# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::ElevationParams do
  let(:instance) { described_class.new(long:, lat:, dataset:) }

  let(:long) { 10.0 }
  let(:lat) { -20.0 }
  let(:dataset) { :srtmgl3 }

  describe "#to_params, #to_h" do
    let(:expected_params) do
      {
        longitude: long,
        latitude: lat,
        dataset: "SRTM_GL3"
      }
    end

    it { expect(instance.to_params).to eq(expected_params) }
    it { expect(instance.to_h).to eq(expected_params) }
  end

  describe "#validate!" do
    let(:validator) { instance_double(OpenTopo::Net::Params::Contracts::ElevationContract) }
    let(:validation_result) { double(success?: true) }

    it "calls elevation contract" do
      expect(OpenTopo::Net::Params::Contracts::ElevationContract).to receive(:new).and_return(validator)
      expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

      expect(instance.validate!).to eq true
    end
  end

  describe "#valid?" do
    let(:validator) { instance_double(OpenTopo::Net::Params::Contracts::ElevationContract) }
    let(:validation_result) { double(success?: true) }

    it "calls elevation contract" do
      expect(OpenTopo::Net::Params::Contracts::ElevationContract).to receive(:new).and_return(validator)
      expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

      expect(instance.valid?).to eq true
    end
  end

  xdescribe "#error_messages" # TODO: rewrite with less dependency
end
