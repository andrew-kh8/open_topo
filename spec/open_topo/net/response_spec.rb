# frozen_string_literal: true

RSpec.describe OpenTopo::Net::Response do
  let(:instance) { described_class.new(foreign_response) }
  let(:foreign_response) do
    double("ForeignResponse",
      body: body,
      status:,
      headers: {
        "Date" => date,
        "Content-Disposition" => content_disposition,
        "Content-Length" => content_length,
        "Content-Type" => content_type,
        "Example-Header" => "example-value"
      })
  end
  let(:body) { "response body" }
  let(:status) { 200 }
  let(:date) { "Wed, 20 Aug 2026 20:35:00 GMT" }
  let(:content_disposition) { "attachment; filename=file.txt" }
  let(:content_length) { "123" }
  let(:content_type) { "text/plain" }

  describe OpenTopo::Net::Response::Headers do
    let(:headers_instance) { described_class.new(date, content_disposition, content_length, content_type) }

    describe "#filename" do
      context "when Content-Disposition header is present" do
        it "extracts the filename from the Content-Disposition header" do
          expect(headers_instance.filename).to eq("file")
        end
      end

      context "when Content-Disposition header is nil" do
        let(:content_disposition) { nil }

        it "returns nil" do
          expect(headers_instance.filename).to be_nil
        end
      end

      context "when Content-Disposition header does not contain a filename" do
        let(:content_disposition) { "attachment" }

        it "returns nil" do
          expect(headers_instance.filename).to be_nil
        end
      end
    end
  end

  describe "#initialize" do
    it "sets the body, headers, and status" do
      expect(instance.body).to eq(body)
      expect(instance.status).to eq(status)

      expect(instance.headers.date).to eq(date)
      expect(instance.headers.content_disposition).to eq(content_disposition)
      expect(instance.headers.content_length).to eq(content_length)
      expect(instance.headers.content_type).to eq(content_type)

      expect(instance.headers.values.compact.size).to eq(4)
    end

    context "when status is 404" do
      let(:status) { 404 }

      it "set body as default text" do
        expect(instance.body).to eq("Not found")
        expect(instance.status).to eq(404)

        expect(instance.headers.date).to eq(date)
        expect(instance.headers.content_disposition).to eq(content_disposition)
        expect(instance.headers.content_length).to eq(content_length)
        expect(instance.headers.content_type).to eq(content_type)

        expect(instance.headers.values.compact.size).to eq(4)
      end
    end

    context "when status is 204" do
      let(:status) { 204 }

      it "set body as default text" do
        expect(instance.body).to eq("No data")
        expect(instance.status).to eq(204)

        expect(instance.headers.date).to eq(date)
        expect(instance.headers.content_disposition).to eq(content_disposition)
        expect(instance.headers.content_length).to eq(content_length)
        expect(instance.headers.content_type).to eq(content_type)

        expect(instance.headers.values.compact.size).to eq(4)
      end
    end
  end

  describe "#success?" do
    subject { instance.success? }

    context "when the status code is 199" do
      let(:status) { 199 }
      it { is_expected.to be false }
    end

    context "when the status code is 200" do
      let(:status) { 200 }
      it { is_expected.to be true }
    end

    context "when the status code is 299" do
      let(:status) { 299 }
      it { is_expected.to be true }
    end

    context "when the status code is outside the 200-299 range" do
      let(:status) { 404 }

      it { is_expected.to be false }
    end
  end

  describe "#failure?" do
    subject { instance.failure? }

    context "when the status code is 199" do
      let(:status) { 199 }
      it { is_expected.to be true }
    end

    context "when the status code is 200" do
      let(:status) { 200 }
      it { is_expected.to be false }
    end

    context "when the status code is 299" do
      let(:status) { 299 }
      it { is_expected.to be false }
    end

    context "when the status code is outside the 200-299 range" do
      let(:status) { 404 }

      it { is_expected.to be true }
    end
  end
end
