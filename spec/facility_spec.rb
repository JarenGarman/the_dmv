# frozen_string_literal: true

require_relative 'spec_helper'

describe Facility do
  subject(:facility) do
    described_class.new({
                          name: 'DMV Tremont Branch',
                          address: '2855 Tremont Place Suite 118 Denver CO 80205',
                          phone: '(720) 865-4600'
                        })
  end

  let(:cruz) do
    Vehicle.new({ vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice })
  end
  let(:bolt) do
    Vehicle.new({ vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev })
  end
  let(:camaro) do
    Vehicle.new({ vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice })
  end

  describe '#initialize' do
    it { is_expected.to be_an_instance_of(described_class) }

    it 'has a name' do
      expect(facility.name).to eq('DMV Tremont Branch')
    end

    it 'has an address' do
      expect(facility.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
    end

    it 'has a phone number' do
      expect(facility.phone).to eq('(720) 865-4600')
    end

    it 'has services' do
      expect(facility.services).to eq([])
    end

    it 'has registered vehicles' do
      expect(facility.registered_vehicles).to eq([])
    end

    it 'has collected fees' do
      expect(facility.collected_fees).to eq(0)
    end
  end

  describe '#add service' do
    it 'can add available services' do
      facility.add_service('New Drivers License')
      facility.add_service('Renew Drivers License')
      facility.add_service('Vehicle Registration')
      expect(facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#register vehicle' do
    let(:second_facility) do
      described_class.new({
                            name: 'DMV Other Branch',
                            address: 'Some other address',
                            phone: '(888) 888 - 8888'
                          })
    end

    before do
      facility.add_service('Vehicle Registration')
      facility.register_vehicle(cruz)
    end

    it 'gives vehicle registration date' do
      expect(cruz.registration_date).not_to be_nil
    end

    it 'gives vehicle plate type' do
      expect(cruz.plate_type).to eq(:regular)
    end

    it 'stores registered vehicle' do
      expect(facility.registered_vehicles).to eq([cruz])
    end

    it 'collects fee' do
      expect(facility.collected_fees).to eq(100)
    end

    it 'can issue antique plate type' do
      facility.register_vehicle(camaro)

      expect(camaro.plate_type).to eq(:antique)
    end

    it 'can issue ev plate type' do
      facility.register_vehicle(bolt)

      expect(bolt.plate_type).to eq(:ev)
    end

    it 'collects appropriate fees' do
      facility.register_vehicle(camaro)
      facility.register_vehicle(bolt)

      expect(facility.collected_fees).to eq(325)
    end

    it 'does not affect other facilities' do
      expect(second_facility.registered_vehicles).to eq([])
    end

    it 'cannot register vehicle if facility does not offer that service' do
      expect(second_facility.register_vehicle(bolt)).to be_nil
    end
  end

  describe '#administer written test' do
    let(:first_registrant) { Registrant.new('Bruce', 18, true) }
    let(:second_registrant) { Registrant.new('Penny', 16) }
    let(:third_registrant) { Registrant.new('Tucker', 15) }

    context 'when the facility cannot administer written tests' do
      it 'does not administer test' do
        facility.administer_written_test(first_registrant)

        expect(first_registrant.license_data).to eq({ written: false, license: false, renewed: false })
      end
    end

    context 'when the facility can administer written tests' do
      before do
        facility.add_service('Written Test')
      end

      context 'when the applicant is not old enough' do
        subject(:applicant) { third_registrant }

        it 'does not administer test' do
          expect(facility.administer_written_test(applicant)).to be false
        end
      end

      context 'when the applicant is old enough' do
        subject(:applicant) { second_registrant }

        context 'when the applicant does not have a permit' do
          it 'does not administer test' do
            expect(facility.administer_written_test(applicant)).to be false
          end
        end

        context 'when the applicant has a permit' do
          before do
            applicant.earn_permit
          end

          it 'administers test' do
            expect(facility.administer_written_test(applicant)).to be true
          end

          it 'sets written to true' do
            facility.administer_written_test(applicant)

            expect(applicant.license_data).to eq({ written: true, license: false, renewed: false })
          end
        end
      end
    end
  end

  describe '#administer road test' do
    let(:applicant) { Registrant.new('Bruce', 18, true) }

    context 'when applicant has not completed written test or facility does not offer service' do
      it 'does not administer test' do
        expect(facility.administer_road_test(applicant)).to be false
      end
    end

    context 'when applicant has completed written test and facility offers service' do
      before do
        facility.add_service('Written Test')
        facility.add_service('Road Test')
        facility.administer_written_test(applicant)
      end

      it 'administers test' do
        expect(facility.administer_road_test(applicant)).to be true
      end

      it 'sets license to true' do
        facility.administer_road_test(applicant)

        expect(applicant.license_data).to eq({ written: true, license: true, renewed: false })
      end
    end
  end

  describe '#renew drivers license' do
    let(:applicant) { Registrant.new('Bruce', 18, true) }

    context 'when applicant is not licensed or facility does not offer service' do
      it 'does not administer test' do
        expect(facility.renew_drivers_license(applicant)).to be false
      end
    end

    context 'when applicant is licensed and facility offers service' do
      before do
        facility.add_service('Written Test')
        facility.add_service('Road Test')
        facility.add_service('Renew License')
        facility.administer_written_test(applicant)
        facility.administer_road_test(applicant)
      end

      it 'renews license' do
        expect(facility.renew_drivers_license(applicant)).to be true
      end

      it 'sets renewed to true' do
        facility.administer_road_test(applicant)

        expect(applicant.license_data).to eq({ written: true, license: true, renewed: true })
      end
    end
  end
end
