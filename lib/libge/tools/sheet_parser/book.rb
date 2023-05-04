# frozen_string_literal: true

module Libge
  module Tools
    module SheetParser
      Book = Struct.new(
        :title,
        :author,
        :brief,
        :pages,
        :age,
        :lang,
        :translator,
        :publishing,
        :status,
        :image
      )
    end
  end
end
