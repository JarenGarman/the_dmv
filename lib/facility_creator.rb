# frozen_string_literal: true

# # Parses API data and creates facilities
class FacilityCreator
  def create_facilities(facilities)
    facilities.map do |facility|
      Facility.new({
                     name: parse_name(facility),
                     address: parse_address(facility),
                     phone: parse_phone(facility),
                     holidays_closed: facility[:holidaysclosed]
                   })
    end
  end

  def parse_name(facility)
    if facility.include?(:office_name)
      facility.fetch_values(:office_name, :office_type).map do |name_array|
        name_array.split.map(&:capitalize)
      end.join(' ')
    elsif facility.include?(:dmv_office)
      facility[:dmv_office]
    elsif facility.include?(:name)
      facility[:name]
    end
  end

  def parse_address(facility)
    "#{unless facility[:street_address_line_1].nil?
         facility[:street_address_line_1].split.map(&:capitalize).join(' ')
       end}#{facility[:address_li]}#{unless facility[:address__1].nil?
                                       ", #{facility[:address__1]}"
                                     end}#{facility[:address1]}, " \
       "#{facility[:city].split.map(&:capitalize).join(' ')}, #{facility[:state]} " \
       "#{facility[:zip]}#{facility[:zipcode]}#{facility[:zip_code]}"
  end

  def parse_phone(facility)
    if facility.include?(:phone)
      facility[:phone]
    elsif facility.include?(:public_phone_number)
      "(#{facility[:public_phone_number][0..2]}) " \
        "#{facility[:public_phone_number][3..5]}-" \
        "#{facility[:public_phone_number][6..9]}"
    end
  end
end
