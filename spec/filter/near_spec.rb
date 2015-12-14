require 'spec_helper'

RSpec.describe Elasticband::Filter::Near do
  describe '#to_h' do
    subject { described_class.new(options).to_h }

    context 'with `:latitude` and `:longitude` option' do
      let(:options) { { latitude: 12.5, longitude: -34.6 } }

      it 'contains the given latitude and longitude options' do
        is_expected.to eq(
          geo_distance: {
            location: { lat: 12.5, lon: -34.6 },
            distance: '100km',
            distance_type: :arc
          }
        )
      end
    end

    context 'with `:on` option' do
      let(:options) { { on: :loc, latitude: 12.5, longitude: -34.6 } }

      it 'contains the given on option' do
        is_expected.to eq(
          geo_distance: {
            loc: { lat: 12.5, lon: -34.6 },
            distance: '100km',
            distance_type: :arc
          }
        )
      end
    end

    context 'with `:distance` option' do
      let(:options) { { distance: '5km', latitude: 12.5, longitude: -34.6 } }

      it 'contains the given distance option' do
        is_expected.to eq(
          geo_distance: {
            location: { lat: 12.5, lon: -34.6 },
            distance: '5km',
            distance_type: :arc
          }
        )
      end
    end

    context 'with `:type` option' do
      let(:options) { { distance: '5km', latitude: 12.5, longitude: -34.6, type: :plane } }

      it 'contains the given type option' do
        is_expected.to eq(
          geo_distance: {
            location: { lat: 12.5, lon: -34.6 },
            distance: '5km',
            distance_type: :plane
          }
        )
      end
    end
  end
end
