# frozen_string_literal: true

RSpec.shared_examples "Params validation" do |validator_class|
  let(:validator) { instance_double(validator_class) }

  describe "#validate!" do
    context "when it's valid" do
      let(:validation_result) { instance_double(Dry::Validation::Result, success?: true) }

      it "calls elevation contract" do
        expect(validator_class).to receive(:new).and_return(validator)
        expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

        expect(instance.validate!).to eq true
      end
    end

    context "when not valid" do
      let(:validation_result) { instance_double(Dry::Validation::Result, success?: false, errors: double(messages: [double(text: "error msg")])) }

      it "calls elevation contract" do
        expect(validator_class).to receive(:new).and_return(validator)
        expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

        expect { instance.validate! }.to raise_error(OpenTopo::Errors::ParamsError, "Invalid parameters: error msg")
      end
    end
  end

  describe "#valid?" do
    context "when it's valid" do
      let(:validation_result) { instance_double(Dry::Validation::Result, success?: true) }

      it "calls elevation contract" do
        expect(validator_class).to receive(:new).and_return(validator)
        expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

        expect(instance.valid?).to eq true
      end
    end

    context "when it's not valid" do
      let(:validation_result) { instance_double(Dry::Validation::Result, success?: false) }

      it "calls elevation contract" do
        expect(validator_class).to receive(:new).and_return(validator)
        expect(validator).to receive(:call).with(instance.to_params).and_return(validation_result)

        expect(instance.valid?).to eq false
      end
    end
  end
end
