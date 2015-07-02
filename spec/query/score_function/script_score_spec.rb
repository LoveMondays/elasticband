require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::ScriptScore do
  describe '#to_h' do
    context 'without options' do
      subject { described_class.new('script').to_h }

      it { is_expected.to eq(script_score: { script: 'script' }) }
    end

    context 'with options' do
      subject { described_class.new('script', params: { param_1: :value_1 }).to_h }

      it { is_expected.to eq(script_score: { script: 'script', params: { param_1: :value_1 } }) }
    end
  end
end
