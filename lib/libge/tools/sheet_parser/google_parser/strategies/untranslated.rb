# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Untranslated < Base
    def call(sheet)
      puts "UNTRANSLATED"
      ap sheet
    end
  end
end
