# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser
  class Context
    attr_writer :strategy

    def parse(data, sheet)
      @strategy.call(data, sheet)
    end
  end
end
