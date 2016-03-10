require 'spec_helper'

RSpec.describe Elasticband::Filter::Exists do
  describe '#to_h' do
    subject { described_class.new('user').to_h }

    it { is_expected.to eq(exists: { field: :user }) }
  end
end
