# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Default < Base
    def call(data, sheet)
      books = []
      categories = []

      category = Category.new(
        sheet.title,
        books,
        categories
      )

      sheet.rows.each_with_index do |row, idx|
        # skip headings
        next if idx.zero?

        if category?(row)
          books = []

          categories.push Category.new(
            row[COLS_MAP[:author]],
            books,
            nil
          )
        else
          books.push parse_row(row)
        end
      end

      data.categories.push category
    end
  end
end
