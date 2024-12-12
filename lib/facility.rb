# frozen_string_literal: true

require 'date'

# Stores information about a particular facility
class Facility
  attr_reader :name, :address, :phone, :services, :registered_vehicles, :collected_fees

  def initialize(facility_details)
    @name = facility_details[:name]
    @address = facility_details[:address]
    @phone = facility_details[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    return unless @services.include?('Vehicle Registration')

    vehicle.registration_date = Date.today
    if vehicle.antique?
      vehicle.plate_type = :antique
      @collected_fees += 25
    elsif vehicle.electric_vehicle?
      vehicle.plate_type = :ev
      @collected_fees += 200
    else
      vehicle.plate_type = :regular
      @collected_fees += 100
    end
    @registered_vehicles << vehicle
  end

  def administer_written_test(applicant)
    return false unless applicant.age >= 16 && applicant.permit? && @services.include?('Written Test')

    applicant.license_data[:written] = true
    true
  end

  def administer_road_test(applicant)
    return false unless applicant.license_data[:written] && @services.include?('Road Test')

    applicant.license_data[:license] = true
    true
  end
end
