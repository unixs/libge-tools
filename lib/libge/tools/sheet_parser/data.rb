# frozen_string_literal: true

module Libge
  module Tools
    module SheetParser
      Data = Struct.new(
        :conditions,
        :datetime,
        :changed,
        :categories
      )
    end
  end
end
