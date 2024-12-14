# frozen_string_literal: true

require_relative 'spec_helper'

describe Registrant do
  describe '#initialize' do
    context 'when registrant is licensed' do
      subject(:registrant) { described_class.new('Bruce', 18, true) }

      it { is_expected.not_to be_nil }

      describe '#name' do
        subject(:name) { registrant.name }

        it { is_expected.not_to be_nil }

        it 'returns name as string' do
          expect(registrant.name).to eq('Bruce')
        end
      end

      describe '#age' do
        subject(:age) { registrant.age }

        it { is_expected.not_to be_nil }

        it 'returns age as integer' do
          expect(registrant.age).to eq(18)
        end
      end

      describe '#permit?' do
        subject(:permit?) { registrant.permit? }

        it { is_expected.not_to be_nil }

        it 'returns true' do
          expect(registrant.permit?).to be true
        end
      end

      describe '#license data' do
        subject(:license_data) { registrant.license_data }

        it { is_expected.not_to be_nil }

        it 'returns license data as hash' do
          expect(registrant.license_data).to eq({ written: false, license: false, renewed: false })
        end
      end
    end

    context 'when registrant is not licensed' do
      subject(:registrant) { described_class.new('Penny', 15) }

      it { is_expected.not_to be_nil }

      describe '#name' do
        subject(:name) { registrant.name }

        it { is_expected.not_to be_nil }

        it 'returns name as string' do
          expect(registrant.name).to eq('Penny')
        end
      end

      describe '#age' do
        subject(:age) { registrant.age }

        it { is_expected.not_to be_nil }

        it 'returns age as integer' do
          expect(registrant.age).to eq(15)
        end
      end

      describe '#permit?' do
        subject(:permit?) { registrant.permit? }

        it { is_expected.not_to be_nil }

        it 'returns true' do
          expect(registrant.permit?).to be false
        end
      end

      describe '#license_data' do
        subject(:license_data) { registrant.license_data }

        it { is_expected.not_to be_nil }

        it 'returns license data as hash' do
          expect(registrant.license_data).to eq({ written: false, license: false, renewed: false })
        end
      end
    end
  end

  describe '#earn_permit' do
    let(:registrant) { described_class.new('Penny', 15) }

    it 'can earn permit' do
      registrant.earn_permit

      expect(registrant.permit?).to be true
    end
  end

  describe '#pass_written' do
    let(:registrant) { described_class.new('Penny', 15) }

    it 'sets permit to true' do
      registrant.pass_written

      expect(registrant.license_data[:written]).to be true
    end
  end

  describe '#earn_license' do
    let(:registrant) { described_class.new('Penny', 15) }

    it 'sets license to true' do
      registrant.earn_license

      expect(registrant.license_data[:license]).to be true
    end
  end

  describe '#renew_license' do
    let(:registrant) { described_class.new('Penny', 15) }

    it 'sets renewed to true' do
      registrant.renew_license

      expect(registrant.license_data[:renewed]).to be true
    end
  end
end
