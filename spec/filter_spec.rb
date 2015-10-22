require 'spec_helper'

RSpec.describe Elasticband::Filter do
  describe '#to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to eq(match_all: {}) }
  end

  describe '.parse' do
    subject { described_class.parse(options) }

    context 'with `:only/:except` option' do
      context 'with only `:only` option' do
        context 'with a single clause' do
          let(:options) { { only: { status: :published } } }

          it { is_expected.to eq(term: { status: :published }) }
        end

        context 'with multiple clauses' do
          let(:options) { { only: { status: :published, company_id: 1 } } }

          it { is_expected.to eq(and: [{ term: { status: :published } }, term: { company_id: 1 }]) }
        end

        context 'with a nested attribute' do
          let(:options) { { only: { company: { id: 1 } } } }

          it { is_expected.to eq(term: { 'company.id': 1 }) }
        end

        context 'with multiple values' do
          let(:options) { { only: { status: %i(published rejected) } } }

          it { is_expected.to eq(terms: { status: %i(published rejected) }) }
        end
      end

      context 'with only `:except` option' do
        context 'with a single clause' do
          let(:options) { { except: { status: :published } } }

          it { is_expected.to eq(not: { term: { status: :published } }) }
        end

        context 'with multiple clauses' do
          let(:options) { { except: { status: :published, company_id: 1 } } }

          it 'returns a filtered query with a `not` filter wrapping an `and` filter' do
            is_expected.to eq(
              and: [{ not: { term: { status: :published } } }, not: { term: { company_id: 1 } }]
            )
          end
        end

        context 'with a nested attribute' do
          let(:options) { { except: { company: { id: 1 } } } }

          it { is_expected.to eq(not: { term: { 'company.id': 1 } }) }
        end

        context 'with multiple values' do
          let(:options) { { except: { status: %i(published rejected) } } }

          it { is_expected.to eq(not: { terms: { status: %i(published rejected) } }) }
        end
      end

      context 'with both options' do
        let(:options) { { only: { status: :published }, except: { company_id: 1 } } }

        it { is_expected.to eq(and: [{ term: { status: :published } }, not: { term: { company_id: 1 } }]) }
      end
    end

    context 'with `:includes` option' do
      let(:options) { { includes: ['bar', on: :description] } }

      before do
        expect(Elasticband::Query).to receive(:parse).with('bar', on: :description) { { name: 'query' } }
      end

      it { is_expected.to eq(query: { name: 'query' }) }
    end

    context 'with `:range` option' do
      context 'with one range' do
        let(:options) { { range: { foo: { gt: 1 } } } }

        it { is_expected.to eq(range: { foo: { gt: 1 } }) }
      end

      context 'with more than one range' do
        let(:options) { { range: { foo: { gt: 1, lt: 2 } } } }

        it { is_expected.to eq(range: { foo: { gt: 1, lt: 2 } }) }
      end
    end

    context 'with `:near` option' do
      let(:options) { { near: { on: :location, latitude: 12.5, longitude: -34.9, distance: '5km' } } }
      let(:filter) { { geo_distance: { location: { lat: 12.5, lon: -34.9 }, distance: '5km' } } }

      it { is_expected.to eq(filter) }
    end

    context 'with `:script` option' do
      let(:options) { { script: ['(param1 + param2) > 0', param1: 1, param2: 1] } }
      let(:filter) { { script: { script: '(param1 + param2) > 0', params: { param1: 1, param2: 1 } } } }

      it { is_expected.to eq(filter) }
    end
  end
end
