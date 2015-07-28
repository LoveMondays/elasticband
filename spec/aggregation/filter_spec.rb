require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Filter do
  describe '#to_h' do
    let(:filter) { Elasticband::Filter.new }

    before { allow(filter).to receive(:to_h) { 'filter' } }

    context 'without options' do
      subject { described_class.new(:aggregation_name, filter).to_h }

      it { is_expected.to eq(aggregation_name: { filter: 'filter' }) }
    end

    context 'with options' do
      subject { described_class.new(:aggregation_name, filter, _cache: true).to_h }

      it { is_expected.to eq(aggregation_name: { filter: 'filter', _cache: true }) }
    end
  end
end
