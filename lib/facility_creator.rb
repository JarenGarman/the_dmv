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
    if facility.include?(:street_address_line_1)
      [
        facility[:street_address_line_1].split.map(&:capitalize).join(' '),
        facility[:city].split.map(&:capitalize).join(' '),
        facility[:state]
      ].join(', ').concat(' ', facility[:zip_code])
    elsif facility.include?(:address_li)
      facility.fetch_values(:address_li, :address__1, :city, :state) do
        nil
      end.compact.join(', ').concat(' ', facility[:zip])
    elsif facility.include?(:address1)
      [
        facility[:address1],
        facility[:city],
        facility[:state]
      ].join(', ').concat(' ', facility[:zipcode])
    end
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
