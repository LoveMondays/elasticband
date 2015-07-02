require 'spec_helper'

RSpec.describe Elasticband::Aggregation::TopHits do
  describe '#to_h' do
    subject { described_class.new(:top_hits_aggregation, root_aggregation, 3).to_h }

    let(:root_aggregation) { Elasticband::Aggregation.new(:root_aggregation) }

    before do
      allow(root_aggregation).to receive(:to_h) { { root_aggregation: { key_1: :value_1 } } }
    end

    it 'returns a nested aggreagation hash' do
      is_expected.to eq(
        root_aggregation: {
          key_1: :value_1,
          aggs: {
            top_hits_aggregation: {
              size: 3
            }
          }
        }
      )
    end
  end
end
