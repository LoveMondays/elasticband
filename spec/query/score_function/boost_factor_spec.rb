require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::BoostFactor do
  describe '.to_h' do
    subject { described_class.new(1.2).to_h }

    it { is_expected.to eq(boost_factor: 1.2) }
  end
end
