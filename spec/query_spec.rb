require 'spec_helper'

RSpec.describe Elasticband::Query do
  describe '#to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to eq(match_all: {}) }
  end

  describe '.parse' do
    context 'with only the query text' do
      subject { described_class.parse('foo') }

      it { is_expected.to eq(match: { _all: 'foo' }) }
    end

    context 'with options' do
      subject { described_class.parse('foo', options) }

      context 'with a single field on `:on` option' do
        let(:options) { { on: :name } }

        it { is_expected.to eq(match: { name: 'foo' }) }
      end

      context 'with multiple fields on `:on` option' do
        let(:options) { { on: %i(name description) } }

        it { is_expected.to eq(multi_match: { query: 'foo', fields: %i(name description) }) }
      end

      context 'with a composed name on `:on` option' do
        let(:options) { { on: 'company.name' } }

        it { is_expected.to eq(match: { 'company.name': 'foo' }) }
      end
    end
  end
end
