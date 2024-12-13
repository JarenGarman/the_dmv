# frozen_string_literal: true

# Parses API data and creates vehicles
class VehicleFactory
  def create_vehicles(registrations)
    registrations.map do |registration|
      Vehicle.new({
                    vin: registration[:vin_1_10],
                    year: registration[:model_year],
                    make: registration[:make],
                    model: registration[:model],
                    engine: registration[:engine]
                  })
    end
  end
end
