require 'spec_helper'

RSpec.describe Elasticband::Search do
  describe '.parse' do
    subject { described_class.parse('foo', on: :name, group_by: :status) }

    before do
      allow(Elasticband::Query).to receive(:parse).with('foo', on: :name, group_by: :status) { 'query' }
      allow(Elasticband::Aggregation).to receive(:parse).with(on: :name, group_by: :status) { 'aggregation' }
    end

    it { is_expected.to eq(query: 'query', aggr: 'aggregation') }
  end
end
