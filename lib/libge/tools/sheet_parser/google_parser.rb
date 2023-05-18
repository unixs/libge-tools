# frozen_string_literal: true

module Libge
  module Tools
    module SheetParser
      module GoogleParser
        CONFIG_NAME = "libge_google_parser"
        CONFIG_SUFFIX = ".conf.json"
        USER_CONFIG_SUFFIX = "rc"
      end
    end
  end
end

require_relative "google_parser/parser"
