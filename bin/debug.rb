# frozen_string_literal: true

require "bundler/setup"
require "libge/tools"
require "awesome_print"

include Libge::Tools::SheetParser::GoogleParser # rubocop:disable Style/MixinUsage

parser = Parser.new

puts parser.parse.to_s
