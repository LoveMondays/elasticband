require 'spec_helper'

RSpec.describe Elasticband::Filter::Terms do
  describe '#to_h' do
    context 'with only one value' do
      subject { described_class.new('filter', :field_name).to_h }

      it { is_expected.to eq(terms: { field_name: ['filter'] }) }
    end

    context 'with multiple values' do
      subject { described_class.new(%w(filter_1 filter_2), :field_name).to_h }

      it { is_expected.to eq(terms: { field_name: %w(filter_1 filter_2) }) }
    end

    context 'with options' do
      subject { described_class.new('filter', :field_name, _cache: true).to_h }

      it { is_expected.to eq(terms: { field_name: ['filter'], _cache: true }) }
    end
  end
end
