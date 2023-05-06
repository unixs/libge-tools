# frozen_string_literal: true

require "google_drive"
require "yaml"

require_relative "strategies"
require_relative "context"


SHEET_KEY = "1HvADoWv1AcyPlieFPLi-681C1L73sTXMdOir_KjTQnI"


module Libge::Tools::SheetParser::GoogleParser
  class Parser
    include Libge::Tools::SheetParser

    attr_reader :data

    FIRST_PAGE_IDX = 0
    UNTRANSLATED_PAGE_IDXS = [7].freeze

    def initialize
      @session = GoogleDrive::Session
        .from_service_account_key("service_secret.json")

      @context = Context.new
      @conditions_sheet = Strategies::Conditions.new
      @default_sheet = Strategies::Default.new
      @untranslated_sheet = Strategies::Untranslated.new
    end

    def parse
      @file = @session.spreadsheet_by_key(SHEET_KEY)
      @data = Data.new(
        [],
        DateTime.now.to_s,
        @file.modified_time.to_s,
        []
      )

      parse_sheets(@data)

      self
    end

    def to_s
      YAML.dump(@data)
    end

    private

    def get_context_strategy(sheet_idx)
      if sheet_idx == FIRST_PAGE_IDX
        # parse first page
        @conditions_sheet
      elsif UNTRANSLATED_PAGE_IDXS.include?(sheet_idx)
        # parse georgian page
        @untranslated_sheet
      else
        # parse other pages
        @default_sheet
      end
    end

    def parse_sheets(data)
      sheets = @file.worksheets

      sheets.each_with_index do |sheet, idx|
        @context.strategy = get_context_strategy(idx)
        @context.parse(data, sheet)
      end
    end
  end
end
