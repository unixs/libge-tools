# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Default < Base
    def call(sheet)
      puts "DEFAULT"
      ap sheet
    end
  end
end
