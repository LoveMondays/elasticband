require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::Filtered do
  describe '.to_h' do
    let(:other_score_function) { double }
    let(:filter) { Elasticband::Filter::Base.new }

    before do
      allow(other_score_function).to receive(:to_h) { { function_name: 'score_function' } }
      allow(filter).to receive(:to_h) { 'filter' }
    end

    context 'without options' do
      subject { described_class.new(filter, other_score_function).to_h }

      it { is_expected.to eq(filter: 'filter', function_name: 'score_function') }
    end

    context 'with options' do
      subject { described_class.new(filter, other_score_function, weight: 2).to_h }

      it { is_expected.to eq(filter: 'filter', function_name: 'score_function', weight: 2) }
    end
  end
end
