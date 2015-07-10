require 'spec_helper'

RSpec.describe Elasticband::Aggregation do
  describe '#to_h' do
    context 'without a aggregation_hash' do
      subject { described_class.new(:aggregation_name).to_h }

      it { is_expected.to eq(aggregation_name: {}) }
    end

    context 'with a aggregation_hash' do
      subject { described_class.new(:aggregation_name).to_h(key: :value) }

      it { is_expected.to eq(aggregation_name: { key: :value }) }
    end

    context 'with special chars' do
      subject { described_class.new('aggregation.name').to_h }

      it { is_expected.to eq(aggregation_name: {}) }
    end
  end

  describe '.parse' do
    subject { described_class.parse(options) }

    context 'with `:group_by` option' do
      context 'with the field_name' do
        let(:options) { { group_by: :status } }

        it { is_expected.to eq(by_status: { terms: { field: :status } }) }
      end

      context 'with an array with field_name and other aggregation' do
        let(:options) { { group_by: [:status, top_hits: 3] } }

        it 'returns the `terms` aggregation with a `top_hits` nested' do
          is_expected.to eq(
            by_status: {
              terms: { field: :status },
              aggs: { top_by_status: { top_hits: { size: 3 } } }
            }
          )
        end
      end

      context 'with an array with field_name and other options' do
        let(:options) { { group_by: [:status, size: 3] } }

        it { is_expected.to eq(by_status: { terms: { field: :status, size: 3 } }) }
      end
    end

    context 'with `:group_max` option' do
      context 'with the field_name' do
        let(:options) { { group_max: :price } }

        it { is_expected.to eq(max_price: { max: { field: :price } }) }
      end

      context 'with an array with field_name and options' do
        let(:options) { { group_max: [:price, script: '_value * 1.2'] } }

        it { is_expected.to eq(max_price: { max: { field: :price, script: '_value * 1.2' } }) }
      end
    end

    context 'with more than one aggregation' do
      let(:options) { { group_by: :status, group_max: :price } }

      it 'returns a hash with all aggregations' do
        is_expected.to eq(
          by_status: { terms: { field: :status } },
          max_price: { max: { field: :price } }
        )
      end
    end
  end
end
