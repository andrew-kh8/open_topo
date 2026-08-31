# frozen_string_literal: true

RSpec.describe OpenTopo::Services::ResponseToCatalogListConverter do
  subject { described_class.call(data) }

  describe ".call" do
    context "when data is empty" do
      let(:data) { {} }
      it { is_expected.to eq [] }
    end
  end
end
