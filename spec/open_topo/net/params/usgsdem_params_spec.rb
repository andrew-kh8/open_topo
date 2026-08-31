# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::UsgsdemParams do
  let(:instance) { described_class.new(south:, north:, west:, east:, dataset_name:, output_format:) }

  let(:south) { -10.0 }
  let(:north) { 10.0 }
  let(:west) { -20.0 }
  let(:east) { 20.0 }
  let(:dataset_name) { :usgs30m }
  let(:output_format) { :tif }

  include_examples "Params validation", OpenTopo::Net::Params::Contracts::UsgsdemContract

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

  xdescribe "#error_messages" # TODO: rewrite with less dependency
end
