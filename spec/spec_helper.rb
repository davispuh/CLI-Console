require 'simplecov'


SimpleCov.start

require_relative '../lib/cli-console.rb'
require 'highline'


if HighLine::CHARACTER_MODE == "Win32API"
  class HighLine
    # Override Windows' character reading so it's not tied to STDIN.
    def get_character( input = STDIN )
      input.getc
    end
  end
end
