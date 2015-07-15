require 'spec_helper'

RSpec.describe Elasticband::Aggregation::TopHits do
  describe '#to_h' do
    context 'without options' do
      subject { described_class.new(:top_hits_aggregation, 3).to_h }

      it { is_expected.to eq(top_hits_aggregation: { top_hits: { size: 3 } }) }
    end

    context 'with options' do
      subject { described_class.new(:top_hits_aggregation, 3, cache: true).to_h }

      it { is_expected.to eq(top_hits_aggregation: { top_hits: { size: 3, cache: true } }) }
    end
  end
end
