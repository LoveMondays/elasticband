require 'spec_helper'

RSpec.describe Elasticband::Query do
  describe '#to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to eq(match_all: {}) }
  end

  describe '.parse' do
    context 'with only the query text' do
      subject { described_class.parse('foo') }

      it { is_expected.to eq(match: { _all: 'foo' }) }
    end
  end
end
