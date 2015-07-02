require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Nested do
  describe '#to_h' do
    subject { described_class.new(root_aggregation, nested_aggregation).to_h }

    let(:root_aggregation) { Elasticband::Aggregation.new(:root_aggregation) }
    let(:nested_aggregation) { Elasticband::Aggregation.new(:nested_aggregation) }

    before do
      allow(root_aggregation).to receive(:to_h) { { root_aggregation: { key_1: :value_1 } } }
      allow(nested_aggregation).to receive(:to_h) { { nested_aggregation: { key_2: :value_2 } } }
    end

    it 'returns a nested aggreagation hash' do
      is_expected.to eq(
        root_aggregation: {
          key_1: :value_1,
          aggs: {
            nested_aggregation: {
              key_2: :value_2
            }
          }
        }
      )
    end
  end
end
