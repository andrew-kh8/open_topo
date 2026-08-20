# frozen_string_literal: true

RSpec.describe OpenTopo::Errors::ResponseError do
  let(:instance) { described_class.new(message) }
  let(:error_message) { "An error occurred" }

  context "when message is a string" do
    let(:message) { error_message }

    it "sets the message correctly" do
      expect(instance.message).to eq(message)
    end
  end

  context "when message is a hash with an 'error' key" do
    let(:message) { {"error" => error_message} }

    it "sets the message to the value of the 'error' key" do
      expect(instance.message).to eq(error_message)
    end
  end

  context "when message is a hash without an 'error' key" do
    let(:message) { {"message" => error_message} }

    it "sets the message to the hash itself" do
      expect(instance.message).to eq(message.to_s)
    end
  end

  context "when message is a nil" do
    let(:message) { nil }

    it "sets the message to nil" do
      expect(instance.message).to eq(described_class.name)
    end
  end
end
