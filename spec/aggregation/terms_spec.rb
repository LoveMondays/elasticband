require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Terms do
  describe '#to_h' do
    context 'without options' do
      subject { described_class.new(:aggregation_name, :field_name).to_h }

      it { is_expected.to eq(aggs: { aggregation_name: { field: :field_name } }) }
    end

    context 'with options' do
      subject { described_class.new(:aggregation_name, :field_name, size: 1).to_h }

      it { is_expected.to eq(aggs: { aggregation_name: { field: :field_name, size: 1 } }) }
    end
  end
end
