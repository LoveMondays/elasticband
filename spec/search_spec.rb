require 'spec_helper'

RSpec.describe Elasticband::Search do
  describe '.parse' do
    subject { described_class.parse('foo', options) }
    let(:options) { { on: :name, group_by: :status, sort: [{ name: :desc }] } }

    before do
      allow(Elasticband::Sort).to receive(:parse).with(options) { sort }
      allow(Elasticband::Query).to receive(:parse).with('foo', options) { query }
      allow(Elasticband::Aggregation).to receive(:parse).with(options) { aggregation }
    end

    context 'with only query' do
      let(:query) { 'query' }
      let(:aggregation) { {} }
      let(:sort) { [] }

      it { is_expected.to eq(query: 'query') }
    end

    context 'with only aggregation' do
      let(:query) { {} }
      let(:aggregation) { 'aggregation' }
      let(:sort) { [] }

      it { is_expected.to eq(aggs: 'aggregation') }
    end

    context 'with only sort' do
      let(:query) { {} }
      let(:aggregation) { {} }
      let(:sort) { [{ name: :desc }] }

      it { is_expected.to eq(sort: [{ name: :desc }]) }
    end

    context 'with query and aggregation and sort' do
      let(:query) { 'query' }
      let(:aggregation) { 'aggregation' }
      let(:sort) { [{ name: :desc }] }

      it { is_expected.to eq(query: 'query', aggs: 'aggregation', sort: [{ name: :desc }]) }
    end
  end
end
