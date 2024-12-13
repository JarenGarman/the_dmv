# frozen_string_literal: true

require_relative 'spec_helper'

describe Vehicle do
  let(:cruz) do
    described_class.new({ vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice })
  end
  let(:bolt) do
    described_class.new({ vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev })
  end
  let(:camaro) do
    described_class.new({ vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice })
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(cruz).to be_an_instance_of(described_class)
      expect(cruz.vin).to eq('123456789abcdefgh')
      expect(cruz.year).to eq(2012)
      expect(cruz.make).to eq('Chevrolet')
      expect(cruz.model).to eq('Cruz')
      expect(cruz.engine).to eq(:ice)
      expect(cruz.registration_date).to be_nil
    end
  end

  describe '#antique?' do
    it 'can determine if a vehicle is an antique' do
      expect(cruz.antique?).to be false
      expect(bolt.antique?).to be false
      expect(camaro.antique?).to be true
    end
  end

  describe '#electric_vehicle?' do
    it 'can determine if a vehicle is an ev' do
      expect(cruz.electric_vehicle?).to be false
      expect(bolt.electric_vehicle?).to be true
      expect(camaro.electric_vehicle?).to be false
    end
  end
end
