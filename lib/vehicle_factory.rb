# frozen_string_literal: true

# Parses API data and creates vehicles
class VehicleFactory
  def create_vehicles(registrations)
    registrations.filter_map do |registration|
      next unless registration[:record_type].nil? || registration[:record_type] == 'VEH'

      Vehicle.new({
                    vin: "#{registration[:vin_1_10]}#{registration[:vin]}",
                    year: registration[:model_year],
                    make: registration[:make],
                    model: registration[:model],
                    engine: (:ev if registration[:record_type].nil?),
                    county: registration[:county]
                  })
    end
  end
end
