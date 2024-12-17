# frozen_string_literal: true

require_relative 'spec_helper'

describe VehicleFactory do
  subject(:factory) { described_class.new }

  let(:wa_vehicle) do
    [{ vin_1_10: 'JTDKN3DP8D', model_year: '2013', make: 'TOYOTA', model: 'Prius Plug-in', county: 'Duval' }]
  end
  let(:ny_vehicle) do
    [{ record_type: 'VEH', vin: '9999236', model_year: '1937', make: 'CHRY',
       county: 'NASSAU' }]
  end

  describe '#initialize' do
    it { is_expected.not_to be_nil }

    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe '#create_vehicles' do
    context 'when given wa data set' do
      let(:test_vehicle) { factory.create_vehicles(wa_vehicle)[0] }

      it 'returns array of vehicles' do
        expect(factory.create_vehicles(DmvDataService.new.wa_ev_registrations).all?(Vehicle)).to be true
      end

      it 'sets correct vin' do
        expect(test_vehicle.vin).to eq('JTDKN3DP8D')
      end

      it 'sets correct year' do
        expect(test_vehicle.year).to eq(2013)
      end

      it 'sets correct make' do
        expect(test_vehicle.make).to eq('TOYOTA')
      end

      it 'sets correct model' do
        expect(test_vehicle.model).to eq('Prius Plug-in')
      end

      it 'sets correct engine' do
        expect(test_vehicle.engine).to eq(:ev)
      end

      it 'sets correct county' do
        expect(test_vehicle.county).to eq('Duval')
      end
    end

    context 'when given ny data set' do
      let(:test_vehicle) { factory.create_vehicles(ny_vehicle)[0] }

      it 'returns array of vehicles' do
        expect(factory.create_vehicles(DmvDataService.new.ny_veh_registrations).all?(Vehicle)).to be true
      end

      it 'sets correct vin' do
        expect(test_vehicle.vin).to eq('9999236')
      end

      it 'sets correct year' do
        expect(test_vehicle.year).to eq(1937)
      end

      it 'sets correct make' do
        expect(test_vehicle.make).to eq('CHRY')
      end

      it 'sets correct model' do
        expect(test_vehicle.model).to be_nil
      end

      it 'sets correct engine' do
        expect(test_vehicle.engine).to be_nil
      end

      it 'sets correct county' do
        expect(test_vehicle.county).to eq('NASSAU')
      end
    end
  end
end
