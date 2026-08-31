# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::Contracts::ElevationContract do
  subject(:validation_result) { described_class.new.call(elevation_params) }

  let(:elevation_params) { {longitude:, latitude:, dataset:} }
  let(:longitude) { -20.0 }
  let(:latitude) { 20.0 }
  let(:dataset) { "ANADEM" }

  describe "parameters validation" do
    include_examples "Longitude with inclusion"
    include_examples "Latitude with inclusion"

    context "when all parameters are valid" do
      it "is success" do
        expect(validation_result).to be_success
        expect(validation_result.errors.to_h).to be_empty
      end
    end

    context "when dataset name is invalid" do
      let(:dataset) { "invalid" }
      it "is failure" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({dataset: ["must be a valid dataset name"]})
      end
    end
  end
end
