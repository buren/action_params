# frozen_string_literal: true

require 'action_params/attribute'

module ActionParams
  class Tree
    def self.build(object)
      case object
      when Array then object.map { |element| build(element) }
      when Hash then build_hash(object)
      else
        Attribute.new(type: type)
      end
    end

    def self.build_hash(hash)
      name = hash.fetch(:name, nil)
      type = hash.fetch(:type)
      exists_on = hash.fetch(:exists_on, nil)
      required_on = hash.fetch(:required_on, nil)
      description = hash.fetch(:description, '')
      one_of = hash.fetch(:one_of, nil)
      of = hash.fetch(:of, nil)
      children = hash.fetch(:children, [])

      Attribute.new(
        name: name,
        type: type,
        exists_on: exists_on,
        required_on: required_on,
        description: description,
        one_of: one_of,
        of: of,
        children: children.map { |child| build(child) }
      )
    end
  end
end
