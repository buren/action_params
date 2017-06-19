# frozen_string_literal: true

module ActionParams
  class Attribute
    attr_reader :name,
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
      @valid = nil
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
      return @valid unless @valid.nil?

      validate
    end

    def validate
      return @valid = false unless children_valid?
      return @valid = false unless one_of_valid?

      @valid = true
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
  end
end
