# frozen_string_literal: true

require "bundler/setup"
require "libge/tools"
require "awesome_print"

ap ARGV

puts Libge::Tools::SheetParser::GoogleParser::Parser.new.parse(ARGV.first).to_s
