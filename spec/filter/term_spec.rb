require 'spec_helper'

RSpec.describe Elasticband::Filter::Term do
  describe '#to_h' do
    context 'without options' do
      subject { described_class.new('filter', :field_name).to_h }

      it { is_expected.to eq(term: { field_name: 'filter' }) }
    end

    context 'with options' do
      subject { described_class.new('filter', :field_name, _cache: true).to_h }

      it { is_expected.to eq(term: { field_name: 'filter', _cache: true }) }
    end
  end
end
