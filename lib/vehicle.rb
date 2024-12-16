# frozen_string_literal: true

require 'date'

# Stores information about a particular vehicle
class Vehicle
  attr_reader :vin,
              :year,
              :make,
              :model,
              :engine,
              :plate_type,
              :registration_date,
              :county

  def initialize(vehicle_details)
    @vin = vehicle_details[:vin]
    @year = vehicle_details[:year].to_i
    @make = vehicle_details[:make]
    @model = vehicle_details[:model]
    @engine = vehicle_details[:engine]
    @plate_type = if antique?
                    :antique
                  elsif electric_vehicle?
                    :ev
                  else
                    :regular
                  end
    @county = vehicle_details[:county]
  end

  def antique?
    Date.today.year - @year > 25
  end

  def electric_vehicle?
    @engine == :ev
  end

  def set_registration_date
    @registration_date = Date.today
  end
end
