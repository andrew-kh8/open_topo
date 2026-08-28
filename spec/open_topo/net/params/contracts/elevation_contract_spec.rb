# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::Contracts::ElevationContract do
  subject(:validation_result) { described_class.new.call(elevation_params) }

  let(:elevation_params) { {longitude:, latitude:, dataset:} }
  let(:longitude) { -20.0 }
  let(:latitude) { 20.0 }
  let(:dataset) { "ANADEM" }

  describe "parameters validation" do
    context "when all parameters are valid" do
      it do
        expect(validation_result).to be_success
        expect(validation_result.errors.to_h).to be_empty
      end

      context "when longitude is 180" do
        let(:longitude) { 180 }
        it { expect(validation_result).to be_success }
      end

      context "when longitude is -180" do
        let(:longitude) { -180 }
        it { expect(validation_result).to be_success }
      end

      context "when latitude is 90" do
        let(:longitude) { 90 }
        it { expect(validation_result).to be_success }
      end

      context "when latitude is -90" do
        let(:longitude) { -90 }
        it { expect(validation_result).to be_success }
      end
    end

    context "when longitude is invalid" do
      context "when it's more than 180" do
        let(:longitude) { 180.1 }
        it "is invalid" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({longitude: ["must be less than or equal to 180"]})
        end
      end

      context "when it's less than -180" do
        let(:longitude) { -180.1 }
        it "is invalid" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({longitude: ["must be greater than or equal to -180"]})
        end
      end
    end

    context "when latitude is invalid" do
      context "when it's more than 90" do
        let(:latitude) { 90.1 }
        it "is invalid" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({latitude: ["must be less than or equal to 90"]})
        end
      end

      context "when it's less than -90" do
        let(:latitude) { -90.1 }
        it "is invalid" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({latitude: ["must be greater than or equal to -90"]})
        end
      end
    end

    context "when dataset name is invalid" do
      let(:dataset) { "invalid" }
      it "it is failure" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({dataset: ["must be a valid dataset name"]})
      end
    end
  end
end
