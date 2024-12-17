# frozen_string_literal: true

require_relative 'lib/dmv_data_service'
require_relative 'lib/dmv'
require_relative 'lib/facility_creator'
require_relative 'lib/facility'
require_relative 'lib/registrant'
require_relative 'lib/vehicle'
require_relative 'lib/vehicle_factory'

puts 'What model year would you like to search for?'
puts
search_year = gets.chomp.to_i
dmv = Dmv.new
creator = FacilityCreator.new
factory = VehicleFactory.new

puts
puts 'Downloading Facility Datasets...'
puts

facility_datasets = [
  DmvDataService.new.co_dmv_office_locations,
  DmvDataService.new.ny_dmv_office_locations,
  DmvDataService.new.mo_dmv_office_locations
]

puts 'Downloading Vehicle Datasets...'
puts

vehicle_datasets = [
  DmvDataService.new.wa_ev_registrations,
  DmvDataService.new.ny_veh_registrations
]

facility_datasets.each do |facility_dataset|
  creator.create_facilities(facility_dataset).each do |facility|
    dmv.add_facility(facility)
    facility.add_service('Vehicle Registration')
  end
end

vehicle_datasets.each do |vehicle_dataset|
  factory.create_vehicles(vehicle_dataset).each do |vehicle|
    dmv.facilities.sample.register_vehicle(vehicle)
  end
end

puts 'Most Popular Make and Model:'
puts dmv.most_popular_make_model
puts

puts "Amount of vehicles from #{search_year}:"
puts dmv.count_model_year(search_year)
puts

puts 'Most Popular County:'
puts dmv.most_popular_county
