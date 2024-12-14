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
end
