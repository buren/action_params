# frozen_string_literal: true

module ActionParams
  module Adapter
    class Apipie
      def self.generate(controller, action, attribute)
        adapter = self
        type = attribute.type

        return unless attribute.exists_on?(action)

        if type == Hash
          controller.param(
            attribute.name,
            apipie_type(attribute),
            of: attribute.of,
            desc: attribute.description,
            required: attribute.required_on?(action)
          ) do
            apipie_instance = self
            attribute.children.each do |child|
              adapter.generate(apipie_instance, action, child)
            end
          end

          return
        end

        unless type == :root
          controller.param(
            attribute.name,
            apipie_type(attribute),
            of: attribute.of,
            desc: attribute.description,
            required: attribute.required_on?(action)
          )
        end

        attribute.children.each { |child| adapter.generate(controller, action, child) }
      end

      def self.apipie_type(attribute)
        type = attribute.one_of || attribute.type
        return type.to_a if type.is_a?(Range)
        return [true, false] if type == :boolean
        return String if type == DateTime

        type
      end
    end
  end
end
