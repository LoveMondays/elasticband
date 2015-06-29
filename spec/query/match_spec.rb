require 'spec_helper'

RSpec.describe Elasticband::Query::Match do
  describe '.to_h' do
    context 'without field' do
      subject { described_class.new('q').to_h }

      it { is_expected.to eq(match: { _all: 'q' }) }
    end

    context 'with a field and no options' do
      subject { described_class.new('q', :field_name).to_h }

      it { is_expected.to eq(match: { field_name: 'q' }) }
    end

    context 'with options' do
      subject { described_class.new('q', :field_name, operator: :and).to_h }

      it { is_expected.to eq(match: { field_name: { query: 'q', operator: :and } }) }
    end
  end
end
