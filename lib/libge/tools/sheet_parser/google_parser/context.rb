# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser
  class Context
    attr_writer :strategy

    def parse(sheet)
      @strategy.call(sheet)
    end
  end
end
