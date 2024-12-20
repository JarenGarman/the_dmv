# frozen_string_literal: true

require_relative 'spec_helper'

describe DmvDataService do
  let(:dds) { described_class.new }

  describe '#initialize' do
    it 'can initialize' do
      expect(dds).to be_an_instance_of(described_class)
    end
  end

  describe '#load_data' do
    it 'can load data from a given source' do
      source = 'https://data.colorado.gov/resource/dsw3-mrn4.json'
      data_response = dds.load_data(source)
      expect(data_response).to be_an_instance_of(Array)
      expect(data_response.size).to be_an(Integer)
    end
  end

  describe '#wa_ev_registrations' do
    it 'can load washington ev registration data' do
      expect(dds.wa_ev_registrations.size).to be_an(Integer)
    end
  end

  describe '#ny_veh_registrations' do
    it 'can load new york vehicle registration data' do
      expect(dds.ny_veh_registrations.size).to be_an(Integer)
    end
  end

  describe '#co_dmv_office_locations' do
    it 'can load colorado dmv office locations' do
      expect(dds.co_dmv_office_locations.size).to be_an(Integer)
    end
  end

  describe '#ny_dmv_office_locations' do
    it 'can load new york dmv office locations' do
      expect(dds.ny_dmv_office_locations.size).to be_an(Integer)
    end
  end

  describe '#mo_dmv_office_locations' do
    it 'can load missouri dmv office locations' do
      expect(dds.mo_dmv_office_locations.size).to be_an(Integer)
    end
  end
end
