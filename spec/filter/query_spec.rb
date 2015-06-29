require 'spec_helper'

RSpec.describe Elasticband::Filter::Query do
  describe '.to_h' do
    let(:query) { double }

    before { allow(query).to receive(:to_h) { 'query' } }

    context 'without options' do
      subject { described_class.new(query).to_h }

      it { is_expected.to eq(query: 'query') }
    end

    context 'with options' do
      subject { described_class.new(query, _cache: true).to_h }

      it { is_expected.to eq(fquery: { query: 'query', _cache: true }) }
    end
  end
end
