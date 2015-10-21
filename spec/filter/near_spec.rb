require 'spec_helper'

RSpec.describe Elasticband::Filter::Near do
  describe '#to_h' do
    subject { described_class.new(options).to_h }

    context 'with `:latidute` and `:latidute` option' do
      let(:options) { { latitude: 12.5, longitude: -34.6 } }

      it { is_expected.to eq(geo_distance: { location: { lat: 12.5, lon: -34.6 }, distance: '100km' }) }
    end

    context 'with `:on` option' do
      let(:options) { { on: :loc, latitude: 12.5, longitude: -34.6 } }

      it { is_expected.to eq(geo_distance: { loc: { lat: 12.5, lon: -34.6 }, distance: '100km' }) }
    end

    context 'with `:distance` option' do
      let(:options) { { distance: '5km', latitude: 12.5, longitude: -34.6 } }

      it { is_expected.to eq(geo_distance: { location: { lat: 12.5, lon: -34.6 }, distance: '5km' }) }
    end
  end
end
