require 'spec_helper'

RSpec.describe Elasticband::Query do
  describe '#to_h' do
    subject { described_class.new.to_h }

    it { is_expected.to eq(match_all: {}) }
  end

  describe '.parse' do
    context 'with no query' do
      subject { described_class.parse('') }

      it { is_expected.to eq(match_all: {}) }
    end

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

          it { is_expected.to eq(match: { :'company.name' => 'foo' }) }
        end
      end

      context 'with filters options' do
        let(:options) { { only: { status: :published } } }

        before { expect(Elasticband::Filter).to receive(:parse).with(options) { { name: 'filter' } } }

        it 'return a filtered query' do
          is_expected.to eq(filtered: { query: { match: { _all: 'foo' } }, filter: { name: 'filter' } })
        end
      end

      context 'with `:boost_by` option' do
        let(:options) { { boost_by: :contents_count } }

        it 'returns a function score query with a `field_value_factor` function' do
          is_expected.to eq(
            function_score: {
              query: { match: { _all: 'foo' } },
              field_value_factor: {
                field: :contents_count,
                modifier: :ln2p
              }
            }
          )
        end

        context 'with `:boost_mode` option' do
          let(:options) { { boost_by: :contents_count, boost_mode: :multiply } }

          it 'returns a function score query with the boost_mode' do
            is_expected.to eq(
              function_score: {
                query: { match: { _all: 'foo' } },
                boost_mode: :multiply,
                field_value_factor: {
                  field: :contents_count,
                  modifier: :ln2p
                }
              }
            )
          end
        end

        context 'with `:score_mode` option' do
          let(:options) { { boost_by: :contents_count, score_mode: :multiply } }

          it 'returns a function score query with the score_mode' do
            is_expected.to eq(
              function_score: {
                query: { match: { _all: 'foo' } },
                score_mode: :multiply,
                field_value_factor: {
                  field: :contents_count,
                  modifier: :ln2p
                }
              }
            )
          end
        end
      end

      context 'with `:boost_function` option' do
        context 'without params' do
          let(:options) { { boost_function: "_score * doc['users_count'].value" } }

          it 'returns a function score query with a `script_score` function' do
            is_expected.to eq(
              function_score: {
                query: { match: { _all: 'foo' } },
                script_score: {
                  script: "_score * doc['users_count'].value"
                }
              }
            )
          end

          context 'with `:boost_mode` option' do
            let(:options) { { boost_function: "_score * doc['users_count'].value", boost_mode: :multiply } }

            it 'returns a function score query with the boost_mode' do
              is_expected.to eq(
                function_score: {
                  query: { match: { _all: 'foo' } },
                  boost_mode: :multiply,
                  script_score: {
                    script: "_score * doc['users_count'].value"
                  }
                }
              )
            end
          end

          context 'with `:score_mode` option' do
            let(:options) { { boost_function: "_score * doc['users_count'].value", score_mode: :multiply } }

            it 'returns a function score query with the score_mode' do
              is_expected.to eq(
                function_score: {
                  query: { match: { _all: 'foo' } },
                  score_mode: :multiply,
                  script_score: {
                    script: "_score * doc['users_count'].value"
                  }
                }
              )
            end
          end
        end

        context 'with params' do
          let(:options) { { boost_function: ['_score * test_param', params: { test_param: 1 }] } }

          it 'returns a function score query with a `script_score` function and params' do
            is_expected.to eq(
              function_score: {
                query: { match: { _all: 'foo' } },
                script_score: {
                  script: '_score * test_param',
                  params: {
                    test_param: 1
                  }
                }
              }
            )
          end
        end
      end

      context 'with `:boost_where` option' do
        context 'with a regular attribute' do
          let(:options) { { boost_where: { status: :published } } }
          let(:filter_options) { { only: { status: :published } } }

          before do
            allow(Elasticband::Filter).to receive(:parse)
            expect(Elasticband::Filter).to receive(:parse).with(filter_options) { { name: 'filter' } }
          end

          it 'returns a function score query with a `boost_factor` filtered function' do
            is_expected.to eq(
              function_score: {
                query: { match: { _all: 'foo' } },
                functions: [
                  {
                    filter: { name: 'filter' },
                    boost_factor: 1000
                  }
                ]
              }
            )
          end

          context 'with `:boost_mode` option' do
            let(:options) { { boost_where: { status: :published }, boost_mode: :multiply } }

            it 'returns a function score query with the boost_mode' do
              is_expected.to eq(
                function_score: {
                  query: { match: { _all: 'foo' } },
                  boost_mode: :multiply,
                  functions: [
                    {
                      filter: { name: 'filter' },
                      boost_factor: 1000
                    }
                  ]
                }
              )
            end
          end

          context 'with `:score_mode` option' do
            let(:options) { { boost_where: { status: :published }, score_mode: :multiply } }

            it 'returns a function score query with the score_mode' do
              is_expected.to eq(
                function_score: {
                  query: { match: { _all: 'foo' } },
                  score_mode: :multiply,
                  functions: [
                    {
                      filter: { name: 'filter' },
                      boost_factor: 1000
                    }
                  ]
                }
              )
            end
          end
        end
      end

      context 'with `:geo_location` options' do
        let(:options) do
          {
            geo_location: {
              latitude: 12.5,
              longitude: -34.9,
              distance: { same_score: '5km', half_score: '10km' }
            }
          }
        end

        it 'returns a function score query with the score_mode' do
          is_expected.to eq(
            function_score: {
              query: { match: { _all: 'foo' } },
              gauss: {
                location: {
                  origin: { lat: 12.5, lon: -34.9 },
                  offset: '5km',
                  scale: '10km'
                }
              }
            }
          )
        end
      end

      context 'with near option' do
        let(:options) { { near: { on: :location, latitude: 12.5, longitude: -34.9, distance: '5km' } } }

        let(:query) { { match: { _all: 'foo' } } }
        let(:filter) do
          { geo_distance: { location: { lat: 12.5, lon: -34.9 }, distance: '5km', distance_type: :arc } }
        end

        it 'return a filtered query by geo_distance' do
          is_expected.to eq(filtered: { query: query, filter: filter })
        end
      end
    end
  end
end
