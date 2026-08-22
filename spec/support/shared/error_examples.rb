# frozen_string_literal: true

RSpec.shared_examples "error_examples" do
  let(:instance) { described_class.new(message) }
  let(:message) { "An error occurred" }

  context "when message is a string" do
    it "sets the message correctly" do
      expect(instance.message).to eq(message)
    end
  end

  context "when message is a hash" do
    let(:message) { {error: "error"} }

    it "sets the message to the value of the 'error' key" do
      expect(instance.message).to eq("{:error=>\"error\"}")
    end
  end

  context "when message is a nil" do
    let(:message) { nil }

    it "sets the message to nil" do
      expect(instance.message).to eq(described_class.name)
    end
  end
end
