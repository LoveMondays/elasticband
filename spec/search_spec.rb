require 'spec_helper'

RSpec.describe Elasticband::Search do
  describe '.parse' do
    subject { described_class.parse('foo', on: :name, group_by: :status) }

    before do
      allow(Elasticband::Query).to receive(:parse).with('foo', on: :name, group_by: :status) { query }
      allow(Elasticband::Aggregation).to receive(:parse).with(on: :name, group_by: :status) { aggregation }
    end

    context 'with only query' do
      let(:query) { 'query' }
      let(:aggregation) { {} }

      it { is_expected.to eq(query: 'query') }
    end

    context 'with only aggregation' do
      let(:query) { {} }
      let(:aggregation) { 'aggregation' }

      it { is_expected.to eq(aggs: 'aggregation') }
    end

    context 'with query and aggregation' do
      let(:query) { 'query' }
      let(:aggregation) { 'aggregation' }

      it { is_expected.to eq(query: 'query', aggs: 'aggregation') }
    end
  end
end
