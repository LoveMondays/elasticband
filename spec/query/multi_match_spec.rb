require 'spec_helper'

RSpec.describe Elasticband::Query::MultiMatch do
  describe '.to_h' do
    context 'with a single field' do
      subject { described_class.new(:field_name, 'q').to_h }

      it { is_expected.to eq(multi_match: { query: 'q', fields: [:field_name] }) }
    end

    context 'with multiple fields' do
      subject { described_class.new([:field_name_1, :field_name_2], 'q').to_h }

      it { is_expected.to eq(multi_match: { query: 'q', fields: [:field_name_1, :field_name_2] }) }
    end

    context 'with options' do
      subject { described_class.new(:field_name, 'q', operator: :and).to_h }

      it { is_expected.to eq(multi_match: { query: 'q', operator: :and, fields: [:field_name] }) }
    end
  end
end
