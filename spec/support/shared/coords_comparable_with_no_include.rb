# frozen_string_literal: true

RSpec.shared_examples "Coordinates comparable with no include" do
  context "when south is invalid" do
    context "when south is eq 90" do
      let(:south) { 90 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({south: ["must be less than 90"]})
      end
    end

    context "when south is eq -90" do
      let(:south) { -90 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({south: ["must be greater than -90"]})
      end
    end

    context "when south is less than -90" do
      let(:south) { -90.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({south: ["must be greater than -90"]})
      end
    end

    context "when south is greater than 90" do
      let(:south) { 90.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({south: ["must be less than 90"]})
      end
    end

    context "when south is equal to north" do
      let(:south) { north }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({south: ["must be less than north (#{north})"]})
      end
    end
  end

  context "when north is invalid" do
    context "when north is eq -90" do
      let(:north) { -90 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({north: ["must be greater than -90"]})
      end
    end

    context "when north is eq 90" do
      let(:north) { 90 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({north: ["must be less than 90"]})
      end
    end

    context "when north is less than -90" do
      let(:north) { -90.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({north: ["must be greater than -90"]})
      end
    end

    context "when north is greater than 90" do
      let(:north) { 90.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({north: ["must be less than 90"]})
      end
    end

    context "when north is equal to south" do
      let(:north) { south }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({south: ["must be less than north (#{north})"]})
      end
    end
  end

  context "when west is invalid" do
    context "when it is eq -180" do
      let(:west) { -180 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({west: ["must be greater than -180"]})
      end
    end

    context "when it is eq 180" do
      let(:west) { 180 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({west: ["must be less than 180"]})
      end
    end

    context "when west is less than -180" do
      let(:west) { -180.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({west: ["must be greater than -180"]})
      end
    end

    context "when west is greater than 180" do
      let(:west) { 180.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({west: ["must be less than 180"]})
      end
    end

    context "when west is equal to east" do
      let(:west) { east }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({west: ["must be less than east (#{east})"]})
      end
    end
  end

  context "when east is invalid" do
    context "when it is eq -180" do
      let(:east) { -180 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({east: ["must be greater than -180"]})
      end
    end

    context "when it is eq 180" do
      let(:east) { 180 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({east: ["must be less than 180"]})
      end
    end

    context "when east is less than -180" do
      let(:east) { -180.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({east: ["must be greater than -180"]})
      end
    end

    context "when east is greater than 180" do
      let(:east) { 180.1 }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({east: ["must be less than 180"]})
      end
    end

    context "when east is equal to west" do
      let(:east) { west }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({west: ["must be less than east (#{east})"]})
      end
    end
  end
end
