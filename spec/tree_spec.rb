# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionParams::Tree do
  describe '#build' do
    it 'builds attribute from hash' do
      result = described_class.build(
        name: :gender,
        type: String,
        required_on: [:create],
        description: 'Gender',
        one_of: %w(male female other)
      )

      expect(result.name).to eq(:gender)
      expect(result.type).to eq(String)
      expect(result.required_on).to eq([:create])
      expect(result.description).to eq('Gender')
      expect(result.one_of).to eq(%w(male female other))
    end

    it 'builds attribute from array of hashes' do
      array = [
        {
          name: :id,
          type: String,
          description: 'ID'
        }
      ]
      first_result = described_class.build(array).first

      expect(first_result.name).to eq(:id)
      expect(first_result.type).to eq(String)
      expect(first_result.description).to eq('ID')
    end
  end
end
