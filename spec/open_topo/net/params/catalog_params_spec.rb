# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::CatalogParams do
  let(:instance) { described_class.new(west:, south:, east:, north:, polygon:) }

  let(:west) { 1 }
  let(:south) { 2 }
  let(:east) { 3 }
  let(:north) { 4 }
  let(:polygon) { "polygon" }

  include_examples "Params validation", OpenTopo::Net::Params::Contracts::CatalogContract

  describe "#to_params, #to_h" do
    context "when polygon provided" do
      let(:expected_params) do
        {
          polygon: polygon,
          productFormat: "Raster",
          outputFormat: "xml",
          detail: false,
          include_federated: false
        }
      end

      it { expect(instance.to_params).to eq(expected_params) }
      it { expect(instance.to_h).to eq(expected_params) }
    end

    context "when polygon is empty" do
      let(:polygon) { nil }
      let(:expected_params) do
        {
          maxx: east,
          minx: west,
          maxy: north,
          miny: south,
          productFormat: "Raster",
          outputFormat: "xml",
          detail: false,
          include_federated: false
        }
      end

      it { expect(instance.to_params).to eq(expected_params) }
      it { expect(instance.to_h).to eq(expected_params) }
    end
  end

  xdescribe "#error_messages" # TODO: rewrite with less dependency
end
