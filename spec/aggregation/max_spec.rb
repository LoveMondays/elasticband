require 'spec_helper'

RSpec.describe Elasticband::Aggregation::Max do
  describe '#type' do
    subject { described_class.new(:aggregation_name, :field_name).type }

    it { is_expected.to eq(:max) }
  end
end
