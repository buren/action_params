# frozen_string_literal: true

require 'date'

require 'action_params/version'
require 'action_params/tree'

module ActionParams
  def self.build(object)
    Tree.build(object)
  end
end
