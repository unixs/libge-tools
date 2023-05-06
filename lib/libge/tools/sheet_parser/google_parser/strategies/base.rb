# frozen_string_literal: true

module Libge::Tools::SheetParser::GoogleParser::Strategies
  class Base
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

    def call
      raise NotImplementedError, "#{self.class} has not
        implemented method '#{__method__}'"
    end
  end
end
