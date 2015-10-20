require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::Gauss do
  describe '#to_h' do
    subject { described_class.new(options).to_h }

    let(:options) { { origin: { lat: 5, lon: 2 } } }

    it { is_expected.to eq(gauss: { origin: { lat: 5, lon: 2 } }) }
  end
end
