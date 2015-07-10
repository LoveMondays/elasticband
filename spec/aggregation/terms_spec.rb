require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Terms do
  describe '#to_h' do
    context 'without options' do
      subject { described_class.new(:aggregation_name, :field_name).to_h }

      it { is_expected.to eq(aggregation_name: { terms: { field: :field_name } }) }
    end

    context 'with options' do
      context 'with field' do
        subject { described_class.new(:aggregation_name, :field_name, size: 1).to_h }

        it { is_expected.to eq(aggregation_name: { terms: { field: :field_name, size: 1 } }) }
      end

      context 'without field' do
        subject { described_class.new(:aggregation_name, nil, script: "doc['field_name'].value").to_h }

        it { is_expected.to eq(aggregation_name: { terms: { script: "doc['field_name'].value" } }) }
      end
    end
  end
end
