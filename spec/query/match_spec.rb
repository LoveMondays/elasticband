require 'spec_helper'

RSpec.describe Elasticband::Query::Match do
  let(:match) { described_class.new(field, query) }

  describe '.to_h' do
    subject { match.to_h }

    let(:field) { :field_name }
    let(:query) { 'q' }

    it { is_expected.to eq(match: { field_name: 'q' }) }
  end
end
