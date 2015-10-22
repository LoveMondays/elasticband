require 'spec_helper'

RSpec.describe Elasticband::Filter::Script do
  describe '#to_h' do
    context 'without params' do
      subject { described_class.new('(param1 + param2) > 0').to_h }

      it { is_expected.to eq(script: { script: '(param1 + param2) > 0' }) }
    end

    context 'with params' do
      subject { described_class.new('(param1 + param2) > 0', param1: 1, param2: 1).to_h }

      it { is_expected.to eq(script: { script: '(param1 + param2) > 0', params: { param1: 1, param2: 1 } }) }
    end
  end
end
