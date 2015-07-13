require 'spec_helper'

RSpec.describe Elasticband::Aggregation::FieldBased do
  describe '#type' do
    subject { described_class.new(:aggregation_name, :field_name).type }

    it { expect { subject }.to raise_error(NotImplementedError) }
  end

  describe '#to_h' do
    subject { aggregation.to_h }

    before { allow(aggregation).to receive(:type) { :aggregation_type } }

    context 'without options' do
      let(:aggregation) { described_class.new(:aggregation_name, :field_name) }

      it { is_expected.to eq(aggregation_name: { aggregation_type: { field: :field_name } }) }
    end

    context 'with options' do
      context 'with field' do
        let(:aggregation) { described_class.new(:aggregation_name, :field_name, size: 1) }

        it { is_expected.to eq(aggregation_name: { aggregation_type: { field: :field_name, size: 1 } }) }
      end

      context 'without field' do
        let(:aggregation) { described_class.new(:aggregation_name, nil, script: "doc['price'].value") }

        it { is_expected.to eq(aggregation_name: { aggregation_type: { script: "doc['price'].value" } }) }
      end
    end
  end
end
