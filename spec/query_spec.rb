require 'spec_helper'

RSpec.describe Elasticband::Query do
  describe '.to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to eq(match_all: {}) }
  end
end
