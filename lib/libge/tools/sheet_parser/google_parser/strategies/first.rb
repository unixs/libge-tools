# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class First < Base
    def call(sheet)
      puts "FIRST"
      ap sheet
    end
  end
end
