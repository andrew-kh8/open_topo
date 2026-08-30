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

  describe "optional attributes" do
    include_examples "Longitude with inclusion", :minx
    include_examples "Longitude with inclusion", :maxx
    include_examples "Latitude with inclusion", :miny
    include_examples "Latitude with inclusion", :maxy
  end

  describe "polygon or bbox rule" do
    context "when bbox is valid and there's no polygon" do
      it { is_expected.to be_success }
    end

    context "when there is polygon and no bbox at all" do
      let(:minx) { nil }
      let(:miny) { nil }
      let(:maxx) { nil }
      let(:maxy) { nil }
      let(:polygon) { "10.0,10.0,20.0,20.0" }

      it { is_expected.to be_success }
    end

    context "when there are polygon and bbox" do
      let(:polygon) { "10.0,10.0,20.0,20.0" }

      it { is_expected.to be_success }
    end

    context "when there is no polygon and no bbox" do
      let(:minx) { nil }
      let(:miny) { nil }
      let(:maxx) { nil }
      let(:maxy) { nil }
      let(:polygon) { nil }

      it "is failure" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq(
          {base: ["either polygon or all bounding box coordinates (west, south, east, north) must be provided"]}
        )
      end
    end
  end

  describe "minx must be less than maxx rule" do
    context "when minx less maxx" do
      it { expect(validation_result).to be_success }
    end

    context "when minx is eq maxx" do
      let(:minx) { maxx }

      it "returns message for west" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h[:west]).to include("must be less than east (#{maxx})")
      end
    end

    context "when minx greater than maxx" do
      let(:minx) { maxx + 1 }

      it "returns message for west" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h[:west]).to include("must be less than east (#{maxx})")
      end
    end
  end

  describe "miny must be less than maxy rule" do
    context "when miny less maxy" do
      it { expect(validation_result).to be_success }
    end

    context "when miny is eq maxy" do
      let(:miny) { maxy }

      it "returns message for south" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h[:south]).to include("must be less than north (#{maxy})")
      end
    end

    context "when miny greater than maxy" do
      let(:miny) { maxy + 1 }

      it "returns message for south" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h[:south]).to include("must be less than north (#{maxy})")
      end
    end
  end

  describe "every coord must be provided rule" do
    context "when minx is empty" do
      let(:minx) { nil }
      it { expect(validation_result.errors.to_h[:west]).to eq(["must be provided"]) }
    end

    context "when minx is empty" do
      let(:miny) { nil }
      it { expect(validation_result.errors.to_h[:south]).to eq(["must be provided"]) }
    end

    context "when maxx is empty" do
      let(:maxx) { nil }
      it { expect(validation_result.errors.to_h[:east]).to eq(["must be provided"]) }
    end

    context "when maxy is empty" do
      let(:maxy) { nil }
      it { expect(validation_result.errors.to_h[:north]).to eq(["must be provided"]) }
    end

    context "when minx maxx are empty" do
      let(:minx) { nil }
      let(:maxx) { nil }

      it "returns message only for 2 coords" do
        expect(validation_result.errors.to_h[:west]).to eq(["must be provided"])
        expect(validation_result.errors.to_h[:east]).to eq(["must be provided"])
        expect(validation_result.errors.to_h).not_to have_key(:south)
        expect(validation_result.errors.to_h).not_to have_key(:north)
      end
    end
  end
end
