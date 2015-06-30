require 'spec_helper'

RSpec.describe Elasticband::Query do
  describe '#to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to eq(match_all: {}) }
  end

  describe '.parse' do
    context 'with only the query text' do
      subject { described_class.parse('foo') }

      it { is_expected.to eq(match: { _all: 'foo' }) }
    end

    context 'with options' do
      subject { described_class.parse('foo', options) }

      context 'with `:on` option' do
        context 'with a single field' do
          let(:options) { { on: :name } }

          it { is_expected.to eq(match: { name: 'foo' }) }
        end

        context 'with multiple fields on `:on` option' do
          let(:options) { { on: %i(name description) } }

          it { is_expected.to eq(multi_match: { query: 'foo', fields: %i(name description) }) }
        end

        context 'with a composed name on `:on` option' do
          let(:options) { { on: 'company.name' } }

          it { is_expected.to eq(match: { 'company.name': 'foo' }) }
        end
      end

      context 'with `:only/:except` option' do
        context 'with only `:only` option' do
          context 'with a single clause' do
            let(:options) { { only: { status: :published } } }

            it 'returns a filtered query with a `term` filter' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: { term: { status: :published } }
                }
              )
            end
          end

          context 'with multiple clauses' do
            let(:options) { { only: { status: :published, company_id: 1 } } }

            it 'returns a filtered query with an `and` filter' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: {
                    and: [
                      { term: { status: :published } },
                      term: { company_id: 1 }
                    ]
                  }
                }
              )
            end
          end

          context 'with a nested attribute' do
            let(:options) { { only: { company: { id: 1 } } } }

            it 'returns a filtered query with a `term` filter on dotted notation' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: { term: { 'company.id': 1 } }
                }
              )
            end
          end

          context 'with multiple values' do
            let(:options) { { only: { status: %i(published rejected) } } }

            it 'returns a filtered query with a `terms` filter' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: { terms: { status: %i(published rejected) } }
                }
              )
            end
          end
        end

        context 'with only `:except` option' do
          context 'with a single clause' do
            let(:options) { { except: { status: :published } } }

            it 'returns a filtered query with a `not` filter wrapping a `term` filter' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: { not: { term: { status: :published } } }
                }
              )
            end
          end

          context 'with multiple clauses' do
            let(:options) { { except: { status: :published, company_id: 1 } } }

            it 'returns a filtered query with a `not` filter wrapping an `and` filter' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: {
                    and: [
                      { not: { term: { status: :published } } },
                      not: { term: { company_id: 1 } }
                    ]
                  }
                }
              )
            end
          end

          context 'with a nested attribute' do
            let(:options) { { except: { company: { id: 1 } } } }

            it 'returns a filtered query with a `not` filter wrapping a `term` filter on dotted notation' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: { not: { term: { 'company.id': 1 } } }
                }
              )
            end
          end

          context 'with multiple values' do
            let(:options) { { except: { status: %i(published rejected) } } }

            it 'returns a filtered query with `not` filter wrapping a `terms` filter' do
              is_expected.to eq(
                filtered: {
                  query: { match: { _all: 'foo' } },
                  filter: { not: { terms: { status: %i(published rejected) } } }
                }
              )
            end
          end
        end

        context 'with both options' do
          let(:options) { { only: { status: :published }, except: { company_id: 1 } } }

          it 'returns a filtered query combining the filters' do
            is_expected.to eq(
              filtered: {
                query: { match: { _all: 'foo' } },
                filter: {
                  and: [
                    { term: { status: :published } },
                    not: { term: { company_id: 1 } }
                  ]
                }
              }
            )
          end
        end
      end
    end
  end
end
