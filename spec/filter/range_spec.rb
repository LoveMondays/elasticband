require 'spec_helper'

RSpec.describe Elasticband::Filter::Range do
  describe '#to_h' do
    subject { described_class.new(:field_name, options).to_h }

    context 'with `:gt` option' do
      let(:options) { { gt: 1 } }

      it { is_expected.to eq(range: { field_name: { gt: 1 } }) }
    end

    context 'with `:gteq` option' do
      let(:options) { { gteq: 1 } }

      it { is_expected.to eq(range: { field_name: { gte: 1 } }) }
    end

    context 'with `:lt` option' do
      let(:options) { { lt: 1 } }

      it { is_expected.to eq(range: { field_name: { lt: 1 } }) }
    end

    context 'with `:lteq` option' do
      let(:options) { { lteq: 1 } }

      it { is_expected.to eq(range: { field_name: { lte: 1 } }) }
    end
  end

  describe '#parsed_ranges' do
    subject { described_class.new(:field_name, options).parsed_ranges }

    context 'with `:gteq` option' do
      let(:options) { { gteq: 1 } }

      it { is_expected.to eq(gte: 1) }
    end

    context 'with `:lteq` option' do
      let(:options) { { lteq: 1 } }

      it { is_expected.to eq(lte: 1) }
    end

    context 'with an unpermitted option' do
      let(:options) { { unpermitted: 1 } }

      it { is_expected.to eq({}) }
    end
  end
end
