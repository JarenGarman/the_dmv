# frozen_string_literal: true

# Stores information about facilities and services offered
class Dmv
  attr_reader :facilities

  def initialize
    @facilities = []
  end

  def add_facility(facility)
    @facilities << facility
  end

  def facilities_offering_service(service)
    @facilities.find_all do |facility|
      facility.services.include?(service)
    end
  end

  def most_popular_make_model
    return if @facilities.map(&:registered_vehicles).empty?

    @facilities.map(&:registered_vehicles).flatten.reject { |vehicle| vehicle.model.nil? }.group_by do |vehicle|
      "#{vehicle.make} #{vehicle.model}"
    end.max_by { |_make_model, vehicle_array| vehicle_array.length }[0]
  end

  def count_model_year(year)
    return if @facilities.map(&:registered_vehicles).empty?

    @facilities.map(&:registered_vehicles).flatten.count { |vehicle| vehicle.year == year }
  end

  def most_popular_county
    return if @facilities.map(&:registered_vehicles).empty?

    @facilities.map(&:registered_vehicles).flatten.group_by(&:county).max_by do |_county, vehicle_array|
      vehicle_array.length
    end[0]
  end
end
