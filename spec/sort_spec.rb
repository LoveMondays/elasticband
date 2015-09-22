require 'spec_helper'

RSpec.describe Elasticband::Sort do
  describe '.parse' do
    subject { described_class.parse(sort: sort_params) }

    context 'with name desc' do
      let(:sort_params) { [{ name: :desc }] }

      it { is_expected.to eq([{ name: :desc }]) }
    end

    context 'with name asc short way' do
      let(:sort_params) { ['+name'] }

      it { is_expected.to eq([{ name: :asc }]) }
    end

    context 'with name desc short way' do
      let(:sort_params) { ['-name'] }

      it { is_expected.to eq([{ name: :desc }]) }
    end

    context 'with name as string' do
      let(:sort_params) { ['name'] }

      it { is_expected.to eq([{ name: :asc }]) }
    end
  end
end
