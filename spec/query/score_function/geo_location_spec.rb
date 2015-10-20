require 'spec_helper'

RSpec.describe Elasticband::Query::ScoreFunction::GeoLocation do
  describe '#to_h' do
    subject { described_class.new(options).to_h }

    let(:options) { { latitude: 5.1, longitude: -2.3, distance: { same_score: '10km', half_score: '15km' } } }
    let(:origin) { { lat: 5.1, lon: -2.3 } }

    it { is_expected.to eq(gauss: { location: { origin: origin, offset: '10km', scale: '15km' } }) }

    context 'with `on` option' do
      let(:options) do
        { on: :loc, latitude: 5.1, longitude: -2.3, distance: { same_score: '10km', half_score: '15km' } }
      end
      let(:origin) { { lat: 5.1, lon: -2.3 } }

      it { is_expected.to eq(gauss: { loc: { origin: origin, offset: '10km', scale: '15km' } }) }
    end

    context 'with nil options' do
      let(:options) { nil }

      it { is_expected.to eq({}) }
    end

    context 'with empty options' do
      let(:options) { {} }

      it { is_expected.to eq({}) }
    end
  end
end
