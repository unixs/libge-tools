# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Untranslated < Base
    COLS_MAP_UNTRANSLATED = {
      status: 6,
      image: 7
    }.freeze

    protected

    def parse_row(row)
      Book.new(
        row[COLS_MAP[:title]],
        row[COLS_MAP[:author]],
        row[COLS_MAP[:brief]],
        row[COLS_MAP[:pages]],
        row[COLS_MAP[:age]],
        row[COLS_MAP[:lang]],
        nil,
        nil,
        row[COLS_MAP_UNTRANSLATED[:status]],
        row[COLS_MAP_UNTRANSLATED[:image]]
      )
    end
  end
end
