require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Max do
  describe '#to_h' do
    context 'without options' do
      subject { described_class.new(:aggregation_name, :field_name).to_h }

      it { is_expected.to eq(aggregation_name: { max: { field: :field_name } }) }
    end

    context 'with options' do
      context 'with field' do
        subject { described_class.new(:aggregation_name, :field_name, script: '_value * 1.2').to_h }

        it { is_expected.to eq(aggregation_name: { max: { field: :field_name, script: '_value * 1.2' } }) }
      end

      context 'without field' do
        subject { described_class.new(:aggregation_name, nil, script: 'doc.score').to_h }

        it { is_expected.to eq(aggregation_name: { max: { script: 'doc.score' } }) }
      end
    end
  end
end
