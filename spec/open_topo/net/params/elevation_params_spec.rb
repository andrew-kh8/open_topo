# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::ElevationParams do
  let(:instance) { described_class.new(long:, lat:, dataset:) }

  let(:long) { 10.0 }
  let(:lat) { -20.0 }
  let(:dataset) { :srtmgl3 }

  include_examples "Params validation", OpenTopo::Net::Params::Contracts::ElevationContract

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

  xdescribe "#error_messages" # TODO: rewrite with less dependency
end
