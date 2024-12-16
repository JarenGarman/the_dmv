# frozen_string_literal: true

require_relative 'spec_helper'

describe Vehicle do
  let(:cruz) do
    described_class.new({ vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice,
                          county: 'Duval' })
  end
  let(:bolt) do
    described_class.new({ vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev,
                          county: 'Duval' })
  end
  let(:camaro) do
    described_class.new({ vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice,
                          county: 'Duval' })
  end

  describe '#initialize' do
    subject(:cruz) do
      described_class.new({ vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice,
                            county: 'Duval' })
    end

    it { is_expected.not_to be_nil }

    it { is_expected.to be_an_instance_of(described_class) }

    describe '#vin' do
      it 'has a vin' do
        expect(cruz.vin).to eq('123456789abcdefgh')
      end
    end

    describe '#year' do
      it 'has a year' do
        expect(cruz.year).to eq(2012)
      end
    end

    describe '#make' do
      it 'has a make' do
        expect(cruz.make).to eq('Chevrolet')
      end
    end

    describe '#model' do
      it 'has a model' do
        expect(cruz.model).to eq('Cruz')
      end
    end

    describe '#engine' do
      it 'has a engine' do
        expect(cruz.engine).to eq(:ice)
      end
    end

    describe '#registration_date' do
      it 'has a registration_date' do
        expect(cruz.registration_date).to be_nil
      end
    end
  end

  describe '#antique?' do
    context 'when vehicle is an antique' do
      subject(:antique) { camaro.antique? }

      it { is_expected.to be true }
    end

    context 'when vehicle is an not antique' do
      subject(:not_antique) { cruz.antique? }

      it { is_expected.to be false }
    end
  end

  describe '#electric_vehicle?' do
    context 'when vehicle is an ev' do
      subject(:ev) { bolt.electric_vehicle? }

      it { is_expected.to be true }
    end

    context 'when vehicle is an not ev' do
      subject(:not_ev) { cruz.electric_vehicle? }

      it { is_expected.to be false }
    end
  end

  describe '#set_registration_date' do
    it 'sets registration date to current date' do
      cruz.set_registration_date

      expect(cruz.registration_date).to eq(Date.today)
    end
  end

  describe '#plate_type' do
    context 'when vehicle is an antique' do
      subject(:antique_plate) { camaro.plate_type }

      it { is_expected.to eq(:antique) }
    end

    context 'when vehicle is an ev' do
      subject(:ev_plate) { bolt.plate_type }

      it { is_expected.to eq(:ev) }
    end

    context 'when vehicle is regular' do
      subject(:regular_plate) { cruz.plate_type }

      it { is_expected.to eq(:regular) }
    end
  end
end
