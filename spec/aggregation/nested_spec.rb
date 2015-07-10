require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Nested do
  describe '#to_h' do
    let(:root_aggregation) { Elasticband::Aggregation.new(:root_aggregation) }
    let(:nested_aggregation_1) { Elasticband::Aggregation.new(:nested_aggregation_1) }
    let(:nested_aggregation_2) { Elasticband::Aggregation.new(:nested_aggregation_2) }
    let(:nested_aggregations) { [nested_aggregation_1, nested_aggregation_2] }

    before do
      allow(nested_aggregation_1).to receive(:to_h) { { nested_aggregation_1: { key_1: :value_1 } } }
      allow(nested_aggregation_2).to receive(:to_h) { { nested_aggregation_2: { key_2: :value_2 } } }
      allow(root_aggregation).to receive(:to_h) { { root_aggregation: { key: :value } } }
    end

    context 'with one aggregation' do
      subject { described_class.new(root_aggregation, nested_aggregation_1).to_h }

      it 'returns a nested aggreagation hash' do
        is_expected.to eq(
          root_aggregation: {
            key: :value,
            aggs: {
              nested_aggregation_1: {
                key_1: :value_1
              }
            }
          }
        )
      end
    end

    context 'with two aggregations' do
      subject { described_class.new(root_aggregation, nested_aggregations).to_h }

      it 'returns a nested aggreagation hash' do
        is_expected.to eq(
          root_aggregation: {
            key: :value,
            aggs: {
              nested_aggregation_1: {
                key_1: :value_1
              },
              nested_aggregation_2: {
                key_2: :value_2
              }
            }
          }
        )
      end
    end
  end
end
