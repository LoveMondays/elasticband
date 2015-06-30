require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction do
  describe '.to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to be_empty }
  end
end
