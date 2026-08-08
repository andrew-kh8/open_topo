# frozen_string_literal: true

require "open_topo/net/params/contracts/globaldem_contract"
require "open_topo/net/params/globaldem_params"

RSpec.describe OpenTopo::Net::Params::Contracts::GlobaldemContract do
  subject(:validation_result) { described_class.new.call(globaldem_params) }

  let(:globaldem_params) do
    {
      south: south,
      north: north,
      west: west,
      east: east,
      demtype: demtype,
      outputFormat: output_format
    }
  end

  let(:south) { -10.0 }
  let(:north) { 10.0 }
  let(:west) { -20.0 }
  let(:east) { 20.0 }
  let(:demtype) { "ANADEM" }
  let(:output_format) { "GTiff" }

  describe "parameters validation" do
    context "when all parameters are valid" do
      it "is successful" do
        expect(validation_result).to be_success
      end
    end

    context "when south or north are invalid" do
      context "when south is less than -90" do
        let(:south) { -100.0 }

        it "is not successful" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({south: ["must be greater than -90"]})
        end
      end

      context "when south is greater than 90" do
        let(:south) { 100.0 }

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

      context "when north is less than -90" do
        let(:north) { -100.0 }

        it "is not successful" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({north: ["must be greater than -90"]})
        end
      end

      context "when north is greater than 90" do
        let(:north) { 100.0 }

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

    context "when west or east are invalid" do
      context "when west is less than -180" do
        let(:west) { -190.0 }

        it "is not successful" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({west: ["must be greater than -180"]})
        end
      end

      context "when west is greater than 180" do
        let(:west) { 190.0 }

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

      context "when east is less than -180" do
        let(:east) { -190.0 }

        it "is not successful" do
          expect(validation_result).to be_failure
          expect(validation_result.errors.to_h).to eq({east: ["must be greater than -180"]})
        end
      end

      context "when east is greater than 180" do
        let(:east) { 190.0 }

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

    context "when demtype is invalid" do
      let(:demtype) { "invalid" }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({demtype: ["must be a valid DEM type"]})
      end
    end

    context "when output_format is invalid" do
      let(:output_format) { "invalid" }

      it "is not successful" do
        expect(validation_result).to be_failure
        expect(validation_result.errors.to_h).to eq({outputFormat: ["must be a valid output format"]})
      end
    end
  end
end
