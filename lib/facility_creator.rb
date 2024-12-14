# frozen_string_literal: true

# # Parses API data and creates facilities
class FacilityCreator
  def create_facilities(facilities)
    facilities.map do |facility|
      Facility.new({
                     name: facility[:dmv_office],
                     address: parse_address(facility),
                     phone: facility[:phone]
                   })
    end
  end

  def parse_address(facility)
    facility.fetch_values(:address_li, :address__1, :city, :state, :zip) { nil }.compact.join(' ')
  end
end
