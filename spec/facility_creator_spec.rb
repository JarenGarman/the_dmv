# frozen_string_literal: true

require_relative 'spec_helper'

describe FacilityCreator do
  subject(:creator) { described_class.new }

  describe '#initialize' do
    it { is_expected.not_to be_nil }

    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe '#create_facilities' do
    it 'returns array of facilities' do
      expect(factory.create_facilities(DmvDataService.new.co_dmv_office_locations).all?(Facility)).to be true
    end
  end

  describe '#parse_address' do
    let(:facility) do
      {
        address_li: '2855 Tremont Place',
        address__1: 'Suite 118',
        city: 'Denver',
        state: 'CO',
        zip: '80205'
      }
    end

    it 'returns properly formatted address' do
      expect(creator.parse_address(facility)).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
    end
  end
end
