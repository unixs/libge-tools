# frozen_string_literal: true

require "google_drive"
require "yaml"

require_relative "strategies"
require_relative "context"


SHEET_KEY = "1HvADoWv1AcyPlieFPLi-681C1L73sTXMdOir_KjTQnI"


module Libge::Tools::SheetParser::GoogleParser
  class Parser
    include Libge::Tools::SheetParser

    FIRST_PAGE_IDX = [0].freeze
    UNTRANSLATED_PAGE_IDXS = [7].freeze


    def initialize
      @data = []
      @session = GoogleDrive::Session
        .from_service_account_key("service_secret.json")

      @context = Context.new
      @first_sheet = Strategies::First.new
      @default_sheet = Strategies::Default.new
      @untranslated_sheet = Strategies::Untranslated.new
    end

    def parse
      @file = @session.spreadsheet_by_key(SHEET_KEY)
      @data = Data.new(
        DateTime.now.to_s,
        @file.modified_time.to_s,
        parse_sheets
      )
    end

    def to_s
      YAML.dump(@data)
    end

    private

    def get_context_strategy(sheet_idx)
      if FIRST_PAGE_IDX.include?(sheet_idx)
        # parse first page
        @first_sheet
      elsif UNTRANSLATED_PAGE_IDXS.include?(sheet_idx)
        # parse georgian page
        @untranslated_sheet
      else
        # parse other pages
        @default_sheet
      end
    end

    def parse_sheets
      categories = []

      sheets = @file.worksheets

      sheets.each_with_index do |sheet, idx|
        @context.strategy = get_context_strategy(idx)
        categories.push @context.parse(sheet)
      end

      categories
    end

    def category?(row)
      !row[COLS_MAP[:author]].empty? &&
        (row[COLS_MAP[:title]].nil? || row[COLS_MAP[:title]].empty?) &&
        (row[COLS_MAP[:status]].nil? || row[COLS_MAP[:status]].empty?)
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
