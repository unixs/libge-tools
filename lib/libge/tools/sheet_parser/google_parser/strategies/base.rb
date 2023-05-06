# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Base
    include Libge::Tools::SheetParser

    COLS_MAP = {
      :title => 1,
      :author => 0,
      :brief => 2,
      :pages => 3,
      :age => 4,
      :lang => 5,
      :translator => 6,
      :publishing => 7,
      :status => 8,
      :image => 9
    }.freeze

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

    protected

    def category?(row)
      !row[COLS_MAP[:author]].empty? &&
        (row[COLS_MAP[:title]].nil? || row[COLS_MAP[:title]].empty?) &&
        (row[COLS_MAP[:status]].nil? || row[COLS_MAP[:status]].empty?)
    end

    def parse_row(row) # rubocop:disable Metrics/AbcSize
      Book.new(
        row[COLS_MAP[:title]],
        row[COLS_MAP[:author]],
        row[COLS_MAP[:brief]],
        row[COLS_MAP[:pages]],
        row[COLS_MAP[:age]],
        row[COLS_MAP[:lang]],
        row[COLS_MAP[:translator]],
        row[COLS_MAP[:publishing]],
        row[COLS_MAP[:status]],
        row[COLS_MAP[:image]]
      )
    end
  end
end
