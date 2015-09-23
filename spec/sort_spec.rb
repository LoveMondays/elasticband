require 'spec_helper'

RSpec.describe Elasticband::Sort do
  describe '.parse' do
    subject { described_class.parse(sort: sort_params) }

    context 'when sort param nil' do
      let(:sort_params) { nil }

      it { is_expected.to be nil }
    end

    context 'when sort is a hash' do
      let(:sort_params) { { name: :desc } }

      it { is_expected.to eq([{ name: :desc }]) }
    end

    context 'when sort is an array of hashes' do
      let(:sort_params) { [{ name: :desc }, { created_at: :asc }] }

      it { is_expected.to eq([{ name: :desc }, { created_at: :asc }]) }
    end

    context 'when sort is a string' do
      let(:sort_params) { '-name,+created_at,id' }

      it { is_expected.to eq([{ name: :desc }, { created_at: :asc }, { id: :asc }]) }
    end

    context 'when sort is array of strings' do
      let(:sort_params) { ['-name', '+created_at', 'id'] }

      it { is_expected.to eq([{ name: :desc }, { created_at: :asc }, { id: :asc }]) }
    end
  end
end
