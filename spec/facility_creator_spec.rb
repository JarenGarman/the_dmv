# frozen_string_literal: true

require_relative 'spec_helper'

describe FacilityCreator do
  subject(:creator) { described_class.new }

  let(:co_facility) do
    { dmv_office: 'DMV Tremont Branch', address_li: '2855 Tremont Place', address__1: 'Suite 118', city: 'Denver',
      state: 'CO', zip: '80205', phone: '(720) 865-4600',
      hours: 'Mon, Tue, Thur, Fri  8:00 a.m.- 4:30 p.m. / Wed 8:30 a.m.-4:30 p.m.' }
  end
  let(:ny_facility) do
    { office_name: 'LAKE PLACID', office_type: 'COUNTY OFFICE', street_address_line_1: '2693 MAIN STREET',
      city: 'LAKE PLACID', state: 'NY', zip_code: '12946', public_phone_number: '5188283350',
      monday_beginning_hours: '9:00 AM',
      monday_ending_hours: '4:45 PM',
      tuesday_beginning_hours: '9:00 AM',
      tuesday_ending_hours: '4:45 PM',
      wednesday_beginning_hours: '9:00 AM',
      wednesday_ending_hours: '4:45 PM',
      thursday_beginning_hours: '9:00 AM',
      thursday_ending_hours: '6:45 PM',
      friday_beginning_hours: '9:00 AM',
      friday_ending_hours: '4:45 PM' }
  end
  let(:mo_facility) do
    { name: 'Harrisonville', address1: '2009 Plaza Dr.', city: 'Harrisonville', state: 'MO', zipcode: '64701',
      phone: '(816) 884-4133', daysopen: 'Monday - Friday 8:00-5:00, Saturday 8:00-12:00' }
  end

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

    it 'can create Missouri facilities' do
      expect(creator.create_facilities(DmvDataService.new.mo_dmv_office_locations).all?(Facility)).to be true
    end
  end

  describe '#parse_name' do
    context 'when given Colorado location' do
      it 'returns name' do
        expect(creator.parse_name(co_facility)).to eq('DMV Tremont Branch')
      end
    end

    context 'when given New York location' do
      it 'returns name' do
        expect(creator.parse_name(ny_facility)).to eq('Lake Placid County Office')
      end
    end

    context 'when given Missouri location' do
      it 'returns name' do
        expect(creator.parse_name(mo_facility)).to eq('Harrisonville')
      end
    end
  end

  describe '#parse_address' do
    context 'when given Colorado location' do
      context 'when facility has a suite number' do
        it 'returns properly formatted address with suite number' do
          expect(creator.parse_address(co_facility)).to eq('2855 Tremont Place, Suite 118, Denver, CO 80205')
        end
      end

      context 'when facility has no suite number' do
        before do
          co_facility.delete(:address__1)
        end

        it 'returns properly formatted address without suite number' do
          expect(creator.parse_address(co_facility)).to eq('2855 Tremont Place, Denver, CO 80205')
        end
      end
    end

    context 'when given New York location' do
      it 'returns properly formatted address' do
        expect(creator.parse_address(ny_facility)).to eq('2693 Main Street, Lake Placid, NY 12946')
      end
    end

    context 'when given Missouri location' do
      it 'returns properly formatted address' do
        expect(creator.parse_address(mo_facility)).to eq('2009 Plaza Dr., Harrisonville, MO 64701')
      end
    end
  end

  describe '#parse_phone' do
    context 'when given Colorado location' do
      it 'returns phone number' do
        expect(creator.parse_phone(co_facility)).to eq('(720) 865-4600')
      end
    end

    context 'when given New York location' do
      it 'returns phone number' do
        expect(creator.parse_phone(ny_facility)).to eq('(518) 828-3350')
      end
    end

    context 'when given Missouri location' do
      it 'returns phone number' do
        expect(creator.parse_phone(mo_facility)).to eq('(816) 884-4133')
      end
    end
  end

  describe '#parse_hours' do
    context 'when given Colorado location' do
      it 'returns hours' do
        expect(creator.parse_hours(co_facility)).to eq('Mon, Tue, Thur, Fri  8:00 a.m.- 4:30 p.m. / Wed 8:30 a.m.-4:30 p.m.')
      end
    end

    context 'when given New York location' do
      it 'returns hours' do
        expect(creator.parse_hours(ny_facility)).to eq({
                                                         monday: '9:00 AM - 4:45 PM',
                                                         tuesday: '9:00 AM - 4:45 PM',
                                                         wednesday: '9:00 AM - 4:45 PM',
                                                         thursday: '9:00 AM - 6:45 PM',
                                                         friday: '9:00 AM - 4:45 PM'
                                                       })
      end
    end

    context 'when given Missouri location' do
      it 'returns hours' do
        expect(creator.parse_hours(mo_facility)).to eq('Monday - Friday 8:00-5:00, Saturday 8:00-12:00')
      end
    end
  end
end
