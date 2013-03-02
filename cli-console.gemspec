# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cli-console/version'


Gem::Specification.new do |gem|
    gem.name          = 'cli-console'
    gem.version       = CLI::Console::VERSION
    gem.authors       = ['Dāvis']
    gem.email         = ['davispuh@gmail.com']
    gem.description   = 'Basic library for making interactive command-line applications much easier'
    gem.summary       = 'Create CLI applications easily'
    gem.homepage      = 'https://github.com/davispuh/CLI-Console'

    gem.files         = `git ls-files`.split($/)
    gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
    gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
    gem.require_paths = ['lib']
end
