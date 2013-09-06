require 'simplecov'

if ENV['CI']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start

require_relative '../lib/cli-console.rb'
require 'highline'
