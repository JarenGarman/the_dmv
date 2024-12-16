# frozen_string_literal: true

require_relative 'spec_helper'

describe Dmv do
  subject(:dmv) { described_class.new }

  let(:first_facility) do
    Facility.new({
                   name: 'DMV Tremont Branch',
                   address: '2855 Tremont Place Suite 118 Denver CO 80205',
                   phone: '(720) 865-4600'
                 })
  end
  let(:second_facility) do
    Facility.new({
                   name: 'DMV Northeast Branch',
                   address: '4685 Peoria Street Suite 101 Denver CO 80239',
                   phone: '(720) 865-4600'
                 })
  end
  let(:third_facility) do
    Facility.new({
                   name: 'DMV Northwest Branch',
                   address: '3698 W. 44th Avenue Denver CO 80211',
                   phone: '(720) 865-4600'
                 })
  end

  describe '#initialize' do
    it { is_expected.to be_an_instance_of(described_class) }

    describe '#facilities' do
      it 'returns empty array' do
        expect(dmv.facilities).to eq([])
      end
    end
  end

  describe '#add_facilities' do
    it 'can add available facilities' do
      dmv.add_facility(first_facility)
      expect(dmv.facilities).to eq([first_facility])
    end
  end

  describe '#facilities_offering_service' do
    before do
      first_facility.add_service('New Drivers License')
      first_facility.add_service('Renew Drivers License')
      second_facility.add_service('New Drivers License')
      second_facility.add_service('Road Test')
      second_facility.add_service('Written Test')
      third_facility.add_service('New Drivers License')
      third_facility.add_service('Road Test')
    end

    it 'can return list of facilities offering a specified Service' do
      dmv.add_facility(first_facility)
      dmv.add_facility(second_facility)
      dmv.add_facility(third_facility)

      expect(dmv.facilities_offering_service('Road Test')).to eq([second_facility, third_facility])
    end
  end

  describe '#most_popular_make_model' do
    subject(:popular) { dmv.most_popular_make_model }

    let(:prius) do
      Vehicle.new({ vin: 'JTDKN3DP8D', year: '2013', make: 'TOYOTA', model: 'Prius Plug-in', engine: :ev })
    end
    let(:mustang) do
      Vehicle.new({ vin: 'adbcdef1234', year: '2022', make: 'FORD', model: 'Mustang Mach-E', engine: :ev })
    end

    context 'when no vehicles have been registered' do
      it { is_expected.to be_nil }
    end

    context 'when vehicles have been registered' do
      before do
        dmv.add_facility(first_facility)
        dmv.add_facility(second_facility)
        first_facility.add_service('Vehicle Registration')
        second_facility.add_service('Vehicle Registration')
        first_facility.register_vehicle(prius)
        first_facility.register_vehicle(mustang)
        second_facility.register_vehicle(prius)
      end

      it 'returns correct make and model' do
        expect(popular).to eq('TOYOTA Prius Plug-in')
      end
    end
  end

  describe '#count_model_year' do
    subject(:count) { dmv.count_model_year(2013) }

    let(:prius) do
      Vehicle.new({ vin: 'JTDKN3DP8D', year: '2013', make: 'TOYOTA', model: 'Prius Plug-in', engine: :ev })
    end
    let(:mustang) do
      Vehicle.new({ vin: 'adbcdef1234', year: '2022', make: 'FORD', model: 'Mustang Mach-E', engine: :ev })
    end

    context 'when no vehicles have been registered' do
      it { is_expected.to be_nil }
    end

    context 'when vehicles have been registered' do
      before do
        dmv.add_facility(first_facility)
        dmv.add_facility(second_facility)
        first_facility.add_service('Vehicle Registration')
        second_facility.add_service('Vehicle Registration')
        first_facility.register_vehicle(prius)
        first_facility.register_vehicle(mustang)
        second_facility.register_vehicle(prius)
      end

      it 'returns correct make and model' do
        expect(count).to eq(2)
      end
    end
  end
end
