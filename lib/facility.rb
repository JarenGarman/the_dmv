# frozen_string_literal: true

require 'date'

# Stores information about a particular facility
class Facility
  @fee_matrix = { regular: 100, antique: 25, ev: 200 }.freeze
  attr_reader :name, :address, :phone, :hours, :holidays_closed, :services, :registered_vehicles, :collected_fees

  def initialize(facility_details)
    @name = facility_details[:name]
    @address = facility_details[:address]
    @phone = facility_details[:phone]
    @hours = facility_details[:hours]
    @holidays_closed = facility_details[:holidays_closed]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  class << self
    attr_reader :fee_matrix
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    return unless @services.include?('Vehicle Registration')

    vehicle.set_registration_date
    @collected_fees += self.class.fee_matrix[vehicle.plate_type]
    @registered_vehicles << vehicle
  end

  def administer_written_test(applicant)
    applicant.pass_written if applicant.age >= 16 && applicant.permit? && @services.include?('Written Test')
    applicant.license_data[:written]
  end

  def administer_road_test(applicant)
    applicant.earn_license if applicant.license_data[:written] && @services.include?('Road Test')
    applicant.license_data[:license]
  end

  def renew_drivers_license(applicant)
    applicant.renew_license if applicant.license_data[:license] && @services.include?('Renew License')
    applicant.license_data[:renewed]
  end
end
