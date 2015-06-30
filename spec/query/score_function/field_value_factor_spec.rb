require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::FieldValueFactor do
  describe '.to_h' do
    context 'without options' do
      subject { described_class.new(:field_name).to_h }

      it { is_expected.to eq(field_value_factor: { field: :field_name }) }
    end

    context 'with options' do
      subject { described_class.new(:field_name, factor: 1.2).to_h }

      it { is_expected.to eq(field_value_factor: { field: :field_name, factor: 1.2 }) }
    end
  end
end
