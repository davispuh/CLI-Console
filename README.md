# CLI::Console
[![Gem Version](https://badge.fury.io/rb/cli-console.png)](http://badge.fury.io/rb/cli-console)

Basic library for making interactive command-line applications much easier.


## Features

* Easy way to add commands and help info to them so it can be shown to user.
* Auto-completion for commands.
* Command aliasing.


## Installation

Simply

`gem install cli-console`

### Dependecies

This library doesn't have any dependencies.
Well actually there's no direct dependencies.
But in reality you do need [HighLine](http://rubygems.org/gems/highline).
Then why I said there's no dependencies?
Because `CLI::Console` will accept any class with implements those few functions which currently are provided by HighLine.

Also, this library requires Ruby version 1.9.x or newer (works fine with 2.0)

## Usage Example

Take a look at [examples/shell.rb](examples/shell.rb)


## Documentation

YARD with markdown is used for documentation

## Specs

RSpec and simplecov are required, to run tests just `rake spec`
code coverage will also be generated

## Code status

[![Build Status](https://travis-ci.org/davispuh/CLI-Console.png?branch=master)](https://travis-ci.org/davispuh/CLI-Console)
[![Dependency Status](https://gemnasium.com/davispuh/CLI-Console.png)](https://gemnasium.com/davispuh/CLI-Console)
[![Coverage Status](https://coveralls.io/repos/davispuh/CLI-Console/badge.png)](https://coveralls.io/r/davispuh/CLI-Console)


## Authors

Currently almost everything (all functions, files, text) in this repository are made by me @davispuh and I've dedicated this repository to public domain.


## Unlicense

![Copyright-Free](http://unlicense.org/pd-icon.png)

All text, documentation, code and files in this repository are in public domain (including this text, README).
It means you can copy, modify, distribute and include in your own work/code, even for commercial purposes, all without asking permission.

[About Unlicense](http://unlicense.org/)
 
## Contributing

Feel free to improve anything what you see is improvable.


**Warning**: By sending pull request to this repository you dedicate any and all copyright interest in pull request (code files and all other) to the public domain. (files will be in public domain even if pull request doesn't get merged)

Also before sending pull request you acknowledge that you own all copyrights or have authorization to dedicate them to public domain.

If you don't want to dedicate code to public domain or if you're not allowed to (eg. you don't own required copyrights) then DON'T send pull request.


