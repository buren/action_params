# frozen_string_literal: true

require 'active_model'

module ActionParams
  class Attribute
    # Required dependency for ActiveModel::Errors
     extend ActiveModel::Naming

    attr_reader :errors,
                :name,
                :type,
                :exists_on,
                :required_on,
                :description,
                :one_of,
                :of,
                :children

    def initialize(
      type:,
      name: nil,
      exists_on: nil,
      required_on: nil,
      description: '',
      one_of: nil,
      of: nil,
      children: []
    )
      @type = type
      @name = name
      @exists_on = exists_on.map(&:to_sym) if exists_on
      @required_on = required_on.map(&:to_sym) if required_on
      @description = description
      @one_of = one_of
      @of = of
      @children = children
      @errors = ActiveModel::Errors.new(self)
    end

    def required_on?(action)
      return false if @required_on.nil?

      @required_on.include?(action.to_sym)
    end

    def exists_on?(action)
      return true if @exists_on.nil?

      @exists_on.include?(action.to_sym)
    end

    def valid?
      validate
    end

    def validate
      errors.clear

      unless children_valid?
        errors.add(:children, :invalid, message: "#{type} cannot children")
      end

      unless one_of_valid?
        errors.add(:one_of, :invalid, message: "#{type} cannot validate one of #{one_of}")
      end

      errors.empty?
    end

    def children_valid?
      return true if children.empty?
      return true if type == :root
      return true if type == Hash
      return true if type == Array

      false
    end

    def one_of_valid?
      return true if one_of.nil?
      return true if type == String
      return true if type < Numeric == true # Check if type has Numeric ancestor

      false
    end

    # For using ActiveModel::Errors
    # the following methods are needed to be minimally implemented

    def read_attribute_for_validation(attribute)
      send(attribute)
    end

    def self.human_attribute_name(attribute, options = {})
      attribute
    end

    def self.lookup_ancestors
      [self]
    end
  end
end
