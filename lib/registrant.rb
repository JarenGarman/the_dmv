# frozen_string_literal: true

# Stores information about a particular registrant
class Registrant
  attr_reader :name, :age, :license_data

  def initialize(name, age, permit = false) # rubocop:disable Style/OptionalBooleanParameter
    @name = name
    @age = age
    @permit = permit
    @license_data = { written: false, license: false, renewed: false }
  end

  def permit?
    @permit
  end

  def earn_permit
    @permit = true
  end
end
