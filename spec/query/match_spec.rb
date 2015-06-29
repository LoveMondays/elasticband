require 'spec_helper'

RSpec.describe Elasticband::Query::Match do

  describe '.to_h' do
    context 'without options' do
      subject { described_class.new(:field_name, 'q').to_h }

      it { is_expected.to eq(match: { field_name: 'q' }) }
    end

    context 'with options' do
      subject { described_class.new(:field_name, 'q', operator: :and).to_h }

      it { is_expected.to eq(match: { field_name: { query: 'q', operator: :and } }) }
    end
  end
end
