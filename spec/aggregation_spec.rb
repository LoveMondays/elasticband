require 'spec_helper'

RSpec.describe Elasticband::Aggregation do
  describe '#to_h' do
    context 'without a aggregation_hash' do
      subject { described_class.new(:aggregation_name).to_h }

      it { is_expected.to eq(aggs: { aggregation_name: {} }) }
    end

    context 'with a aggregation_hash' do
      subject { described_class.new(:aggregation_name).to_h(key: :value) }

      it { is_expected.to eq(aggs: { aggregation_name: { key: :value } }) }
    end
  end
end
