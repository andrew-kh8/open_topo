# frozen_string_literal: true

RSpec.shared_examples "Longitude with inclusion" do |long = :longitude|
  context "when longitude is valid" do
    context "when longitude is 179.99" do
      let(long) { 179.99 }
      it { expect(validation_result.errors.to_h[long]).to eq nil }
    end

    context "when longitude is 180" do
      let(long) { 180 }
      it { expect(validation_result.errors.to_h[long]).to eq nil }
    end

    context "when longitude is -179.99" do
      let(long) { -179.99 }
      it { expect(validation_result.errors.to_h[long]).to eq nil }
    end

    context "when longitude is -180" do
      let(long) { -180 }
      it { expect(validation_result.errors.to_h[long]).to eq nil }
    end
  end

  context "when longitude is invalid" do
    context "when it's more than 180" do
      let(long) { 180.1 }

      it "is invalid" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({long => ["must be less than or equal to 180"]})
      end
    end

    context "when it's less than -180" do
      let(long) { -180.1 }

      it "is invalid" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({long => ["must be greater than or equal to -180"]})
      end
    end
  end
end
