# frozen_string_literal: true

require_relative 'spec_helper'

describe VehicleFactory do
  subject(:factory) { described_class.new }

  describe '#initialize' do
    it { is_expected.not_to be_nil }

    it { is_expected.to be_an_instance_of(described_class) }
  end

  describe '#create vehicles' do
    it 'returns array of vehicles' do
      expect(factory.create_vehicles(wa_ev_registrations).sample).to be_an_instance_of(Vehicle)
    end
  end
end
