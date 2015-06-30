require 'spec_helper'

RSpec.describe Elasticband::Filter::Not do
  describe '.to_h' do
    let(:other_filter) { Elasticband::Filter::Base.new }

    before { allow(other_filter).to receive(:to_h) { 'other_filter' } }

    context 'without options' do
      subject { described_class.new(other_filter).to_h }

      it { is_expected.to eq(not: 'other_filter') }
    end

    context 'with options' do
      subject { described_class.new(other_filter, _cache: true).to_h }

      it { is_expected.to eq(not: { filter: 'other_filter', _cache: true }) }
    end
  end
end
