# frozen_string_literal: true

RSpec.shared_examples "Latitude with inclusion" do |lat = :latitude|
  context "when latitude is valid" do
    context "when latitude is 89.999" do
      let(lat) { 89.999 }
      it { expect(validation_result.errors.to_h[lat]).to eq nil }
    end

    context "when latitude is 90" do
      let(lat) { 90 }
      it { expect(validation_result.errors.to_h[lat]).to eq nil }
    end

    context "when latitude is -89.999" do
      let(lat) { -89.999 }
      it { expect(validation_result.errors.to_h[lat]).to eq nil }
    end

    context "when latitude is -90" do
      let(lat) { -90 }
      it { expect(validation_result.errors.to_h[lat]).to eq nil }
    end
  end

  context "when latitude is invalid" do
    context "when it's more than 90" do
      let(lat) { 90.1 }

      it "is invalid" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({lat => ["must be less than or equal to 90"]})
      end
    end

    context "when it's less than -90" do
      let(lat) { -90.1 }

      it "is invalid" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({lat => ["must be greater than or equal to -90"]})
      end
    end
  end
end
