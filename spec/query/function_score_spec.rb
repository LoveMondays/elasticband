require 'spec_helper'

RSpec.describe Elasticband::Query::FunctionScore do
  describe '#to_h' do
    let(:other_query) { Elasticband::Query.new }
    let(:filter) { Elasticband::Filter.new }
    let(:score_function_1) { Elasticband::Query::ScoreFunction.new }
    let(:score_function_2) { Elasticband::Query::ScoreFunction.new }

    before do
      allow(other_query).to receive(:to_h) { 'query' }
      allow(filter).to receive(:to_h) { 'filter' }
      allow(score_function_1).to receive(:to_h) { { score_function_1: 'score_function_1' } }
      allow(score_function_2).to receive(:to_h) { { score_function_2: 'score_function_2' } }
    end

    context 'with a single function' do
      context 'with a query' do
        subject { described_class.new(other_query, score_function_1).to_h }

        it { is_expected.to eq(function_score: { query: 'query', score_function_1: 'score_function_1' }) }
      end

      context 'with filter' do
        subject { described_class.new(filter, score_function_1).to_h }

        it { is_expected.to eq(function_score: { filter: 'filter', score_function_1: 'score_function_1' }) }
      end
    end

    context 'with multiple functions' do
      subject { described_class.new(other_query, [score_function_1, score_function_2]).to_h }

      it 'returns a hash with the query/filter and an array with the functions' do
        is_expected.to eq(
          function_score: {
            query: 'query',
            functions: [
              { score_function_1: 'score_function_1' },
              { score_function_2: 'score_function_2' }
            ]
          }
        )
      end
    end

    context 'with options' do
      subject { described_class.new(other_query, score_function_1, boost: 1.2).to_h }

      it 'returns a hash with the query, function and options' do
        is_expected.to eq(
          function_score: {
            query: 'query',
            score_function_1: 'score_function_1',
            boost: 1.2
          }
        )
      end
    end
  end
end
