# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Conditions < Base
    def call(data, sheet)
      sheet.rows.each_with_index do |row, idx|
        # skip headings
        next if idx.zero?

        data.conditions.push row.first
      end
    end
  end
end
