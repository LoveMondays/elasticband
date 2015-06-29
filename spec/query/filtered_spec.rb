require 'spec_helper'

RSpec.describe Elasticband::Query::Filtered do
  describe '.to_h' do
    let(:other_query) { double }
    let(:filter) { double }

    before do
      allow(other_query).to receive(:to_h) { 'query' }
      allow(filter).to receive(:to_h) { 'filter' }
    end

    context 'with only filter' do
      subject { described_class.new(filter).to_h }

      it { is_expected.to eq(filtered: { filter: 'filter' }) }
    end

    context 'with filter and query' do
      subject { described_class.new(filter, other_query).to_h }

      it { is_expected.to eq(filtered: { query: 'query', filter: 'filter' }) }
    end

    context 'with filter and options' do
      subject { described_class.new(filter, nil, strategy: :leap_frog).to_h }

      it { is_expected.to eq(filtered: { filter: 'filter', strategy: :leap_frog }) }
    end

    context 'with filter, query and options' do
      subject { described_class.new(filter, other_query, strategy: :leap_frog).to_h }

      it { is_expected.to eq(filtered: { query: 'query', filter: 'filter', strategy: :leap_frog }) }
    end
  end
end
