# frozen_string_literal: true

# # Parses API data and creates facilities
class FacilityCreator
  def create_facilities(facilities)
    facilities.map do |facility|
      Facility.new({
                     name: parse_name(facility),
                     address: parse_address(facility),
                     phone: parse_phone(facility)
                   })
    end
  end

  def parse_name(facility)
    facility.fetch_values(:dmv_office, :office_name, :office_type, :name) { nil }.compact.join(' ')
  end

  def parse_address(facility)
    facility.fetch_values(:address_li, :address__1, :street_address_line_1, :address1, :city, :state, :zip, :zip_code,
                          :zipcode) { nil }.compact.join(' ')
  end

  def parse_phone(facility)
    facility.fetch_values(:phone, :public_phone_number) { nil }.compact.join
  end
end
