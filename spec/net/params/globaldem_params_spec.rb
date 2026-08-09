# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Params::GlobaldemParams do
  let(:instance) { described_class.new(south:, north:, west:, east:, demtype:, output_format:) }

  let(:south) { -10.0 }
  let(:north) { 10.0 }
  let(:west) { -20.0 }
  let(:east) { 20.0 }
  let(:demtype) { :anadem }
  let(:output_format) { :tif }

  describe "#to_params, #to_h" do
    let(:expected_params) do
      {
        south: south,
        north: north,
        west: west,
        east: east,
        demtype: "ANADEM",
        outputFormat: "GTiff"
      }
    end

    it "returns a hash with the correct keys and values" do
      expect(instance.to_params).to eq(expected_params)
    end

    it "returns a hash with the correct keys and values" do
      expect(instance.to_h).to eq(expected_params)
    end
  end

  describe "#validate!" do
    context "when the parameters are valid" do
      it "does not raise an error" do
        expect { instance.validate! }.not_to raise_error
      end
    end

    context "when the parameters are invalid" do
      let(:south) { -100.0 }
      let(:error_message) { "Invalid parameters: south must be greater than -90" }

      it "raises a ParamsError with the correct error messages" do
        expect { instance.validate! }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
      end
    end
  end

  describe "#valid?" do
    context "when the parameters are valid" do
      it "returns true" do
        expect(instance.valid?).to eq true
      end
    end

    context "when the parameters are invalid" do
      let(:south) { -100.0 }

      it "returns false" do
        expect(instance.valid?).to eq false
      end
    end
  end

  describe "#error_messages" do
    context "when there no validation result" do
      context "when the parameters are valid" do
        it "returns an empty array" do
          expect(instance.error_messages).to eq []
        end
      end

      context "when the parameters are invalid" do
        let(:south) { -100.0 }

        it "returns an array with error messages" do
          expect(instance.error_messages).to eq []
        end
      end
    end

    context "when there is a validation result" do
      before { instance.valid? }

      context "when the parameters are valid" do
        it "returns an empty array" do
          expect(instance.error_messages).to eq []
        end
      end

      context "when the parameters are invalid" do
        let(:south) { -100.0 }

        it "returns an array with error messages" do
          expect(instance.error_messages).to eq ["south must be greater than -90"]
        end
      end
    end
  end
end
