# frozen_string_literal: true

require "google_drive"
require "pry"

SHEET_KEY = "1HvADoWv1AcyPlieFPLi-681C1L73sTXMdOir_KjTQnI"


module Libge
  module Tools
    module SheetParser
      class GoogleParser
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
        }

        def initialize
          @data = []
          @session = GoogleDrive::Session
            .from_service_account_key("config/service_secret.json")
        end

        def parse
          ap "Parse."
          @data = Data.new(
            nil,
            nil,
            parse_sheets
          )
        end

        private

        def category?(row)
          !row[COLS_MAP[:author]].size.zero? &&
            (row[COLS_MAP[:title]].nil? || row[COLS_MAP[:title]].empty?) &&
            (row[COLS_MAP[:status]].nil? || row[COLS_MAP[:status]].empty?)
        end

        def parse_sheets
          categories = []

          ap "Each all sheets"
          sheets = @session.spreadsheet_by_key(SHEET_KEY).worksheets

          to_skip = [0]

          sheets.each_with_index do |sheet, idx|
            ap " Parse sheet: #{sheet.title}"
            next if to_skip.include? idx

            categories.push parse_sheet(sheet)
          end

          categories
        end

        def parse_sheet(sheet)
          books = []
          categories = []

          category = Category.new(
            sheet.title,
            books,
            categories
          )

          sheet.rows.each_with_index do |row, idx|
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

          category
        end

        def parse_row(row)
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
  end
end
