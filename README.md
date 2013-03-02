# CLI::Console


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
But in reality need HighLine and Readline.
Then why I said there's no dependencies?
Because `CLI::Console` will accept any IO class with implements those few functions which currently are provided by HighLine.


## Usage Example

Take a look at [/examples/shell.rb](/davispuh/examples/shell.rb)


## Documentation

YARD with markdown is used for documentation (`redcarpet` required)

## Specs

RSpec and simplecov are required, to run tests just `rake spec`
code coverage will also be generated

## Authors

Currently everything (all functions, files, text) in this repository are made by me @davispuh and I've dedicated this repository to public domain.


## Unlicense

All text, documentation, code and files in this repository are in public domain (including this text, README).
It means you can copy, modify, distribute and include in your own work/code, even for commercial purposes, all without asking permission.


## Contributing

Feel free to improve anything what you see is improvable.


**Warning**: By sending pull request to this repository you dedicate any and all copyright interest in pull request (code files and all other) to the public domain. (files will be in public domain even if pull request doesn't get merged)

Also before sending pull request you acknowledge that you own all copyrights or have authorization to dedicate them to public domain.

If you don't want to dedicate code to public domain or if you're not allowed to (eg. you don't own required copyrights) then DON'T send pull request.


