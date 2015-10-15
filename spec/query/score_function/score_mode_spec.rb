require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::ScoreMode do
  describe '#to_h' do
    subject { described_class.new(mode).to_h }

    let(:mode) { :multiply }

    it { is_expected.to eq(score_mode: :multiply) }

    context 'with an unpermitted mode' do
      let(:mode) { :foo }

      it { is_expected.to be_empty }
    end
  end
end
