require 'spec_helper'

RSpec.describe Elasticband::Filter::And do
  describe '.to_h' do
    let(:filter_1) { double }
    let(:filter_2) { double }

    before do
      allow(filter_1).to receive(:to_h) { 'filter_1' }
      allow(filter_2).to receive(:to_h) { 'filter_2' }
    end

    context 'with only one filter' do
      subject { described_class.new(filter_1).to_h }

      it { is_expected.to eq(and: ['filter_1']) }
    end

    context 'with multiple filters' do
      subject { described_class.new([filter_1, filter_2]).to_h }

      it { is_expected.to eq(and: ['filter_1', 'filter_2']) }
    end

    context 'with options' do
      subject { described_class.new(filter_1, _cache: true).to_h }

      it { is_expected.to eq(and: { filter: ['filter_1'], _cache: true }) }
    end
  end
end
