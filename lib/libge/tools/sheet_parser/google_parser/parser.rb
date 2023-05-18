# frozen_string_literal: true

require "google_drive"
require "yaml"

require_relative "strategies"
require_relative "context"

module Libge::Tools::SheetParser::GoogleParser
  class Parser
    include Libge::Tools::SheetParser

    attr_reader :data

    FIRST_PAGE_IDX = 0
    UNTRANSLATED_PAGE_IDXS = [7].freeze

    def initialize
      @session = GoogleDrive::Session
        .from_service_account_key(get_config_path)

      @context = Context.new
      @conditions_sheet = Strategies::Conditions.new
      @default_sheet = Strategies::Default.new
      @untranslated_sheet = Strategies::Untranslated.new
    end

    def parse(key)
      @file = @session.spreadsheet_by_key(key)
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

    def get_config_path # rubocop:disable Naming/AccessorMethodName
      begin
        path =  if Process.uid.zero?
                  File.realpath(CONFIG_NAME + CONFIG_SUFFIX, '/etc')
                else
                  # check rc-file in $HOME
                  File.realpath(
                    ".#{CONFIG_NAME}#{USER_CONFIG_SUFFIX}",
                    Dir.home
                  )
                end
      rescue SystemCallError
        path = File.realpath(CONFIG_NAME + CONFIG_SUFFIX)
      end

      path
    rescue SystemCallError => e
      warn "Config file not found in cwd and default paths"
      warn e.message

      exit e.errno
    end

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
