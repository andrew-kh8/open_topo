# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::Contracts::CatalogContract do
  subject(:validation_result) { described_class.new.call(elevation_params) }

  let(:elevation_params) do
    {
      maxx:, minx:,
      maxy:, miny:,
      polygon:,
      productFormat: product_format,
      outputFormat: output_format,
      detail: detail,
      include_federated: include_federated
    }.compact
  end
  let(:product_format) { "test" }
  let(:output_format) { "test" }
  let(:detail) { false }
  let(:include_federated) { false }

  let(:maxx) { 121.5 }
  let(:minx) { 121 }
  let(:maxy) { 84.5 }
  let(:miny) { 84 }
  let(:polygon) { nil }

  context "when bbox is valid and there's no polygon" do
    it { is_expected.to be_success }
  end

  describe "required attributes" do
    context "when productFormat is empty" do
      let(:product_format) { nil }
      it { expect(validation_result.errors.to_h[:productFormat]).to include("is missing") }
    end

    context "when outputFormat is empty" do
      let(:output_format) { nil }
      it { expect(validation_result.errors.to_h[:outputFormat]).to include("is missing") }
    end

    context "when detail is empty" do
      let(:detail) { nil }
      it { expect(validation_result.errors.to_h[:detail]).to include("is missing") }
    end

    context "when include_federated is empty" do
      let(:include_federated) { nil }
      it { expect(validation_result.errors.to_h[:include_federated]).to include("is missing") }
    end
  end
end
