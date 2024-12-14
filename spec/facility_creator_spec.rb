# frozen_string_literal: true

require_relative 'spec_helper'

describe FacilityCreator do
  subject(:creator) { described_class.new }

  describe '#initialize' do
    it { is_expected.not_to be_nil }

    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe '#create_facilities' do
    it 'can create Colorado facilities' do
      expect(creator.create_facilities(DmvDataService.new.co_dmv_office_locations).all?(Facility)).to be true
    end

    it 'can create New York facilities' do
      expect(creator.create_facilities(DmvDataService.new.ny_dmv_office_locations).all?(Facility)).to be true
    end
  end

  describe '#parse_address' do
    context 'when given Colorado location' do
      let(:facility) do
        {
          address_li: '2855 Tremont Place',
          address__1: 'Suite 118',
          city: 'Denver',
          state: 'CO',
          zip: '80205'
        }
      end

      context 'when facility has a suite number' do
        it 'returns properly formatted address with suite number' do
          expect(creator.parse_address(facility)).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
        end
      end

      context 'when facility has no suite number' do
        before do
          facility.delete(:address__1)
        end

        it 'returns properly formatted address without suite number' do
          expect(creator.parse_address(facility)).to eq('2855 Tremont Place Denver CO 80205')
        end
      end
    end

    context 'when given New York location' do
      let(:facility) do
        {
          street_address_line_1: '2693 MAIN STREET',
          city: 'LAKE PLACID',
          state: 'NY',
          zip_code: '12946'
        }
      end

      it 'returns properly formatted address' do
        expect(creator.parse_address(facility)).to eq('2693 MAIN STREET LAKE PLACID NY 12946')
      end
    end
  end
end
