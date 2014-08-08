require 'spec_helper'


class UI
    private
    extend CLI::Task

    public

    usage 'Usage: try'
    desc 'try exception'
    def try(params)
        raise CLI::CommandNotFoundError, params[0]
    end
end

describe CLI::Console do
    let(:input) { StringIO.new }
    let(:output) { StringIO.new }
    let(:io) { HighLine.new(input, output) }
    let(:console) { CLI::Console.new(io) }
    let(:ui) { UI.new }

    def init
        console.UseReadline = false
        console.addCommand('try',ui.method(:try))
        console.addHelpCommand('help')
        console.addExitCommand('exit')
        console.addAlias('trymore','try')
        console.addAlias('quit','exit')
    end

    describe '.parseCommandString' do
        it 'should parse correctly simple command' do
            CLI::Console::parseCommandString('command param1 param2').should eq(['command', 'param1', 'param2'])
        end

        it 'should parse command with double quotes' do
            CLI::Console::parseCommandString('command "param1 extra" param2').should eq(['command', 'param1 extra', 'param2'])
            CLI::Console::parseCommandString('command "param1" "param2 extra"').should eq(['command', 'param1', 'param2 extra'])
        end

        it 'should parse command with single quotes' do
            CLI::Console::parseCommandString('command \'param1 extra\' param2').should eq(['command', 'param1 extra', 'param2'])
            CLI::Console::parseCommandString('command \'param1\' \'param2 extra\'').should eq(['command', 'param1', 'param2 extra'])
        end

        it 'should parse command with mixed quotes' do
            CLI::Console::parseCommandString('command "param1 \'extra double\'" param2').should eq(['command', 'param1 \'extra double\'', 'param2'])
            CLI::Console::parseCommandString('command "param1" "param2 \'double extra\'"').should eq(['command', 'param1', 'param2 \'double extra\''])
            CLI::Console::parseCommandString('command \'param1 "extra double"\' param2').should eq(['command', 'param1 "extra double"', 'param2'])
            CLI::Console::parseCommandString('command \'param1\' \'param2 "double extra"\'').should eq(['command', 'param1', 'param2 "double extra"'])
        end

        it 'should parse command with escaped quotes' do
            CLI::Console::parseCommandString('command "param with \" quote"').should eq(['command', 'param with " quote'])
            CLI::Console::parseCommandString('command \'param with \\\' quote\'').should eq(['command', 'param with \' quote'])
        end

        it 'should parse command with escaped quotes in quotes' do
            CLI::Console::parseCommandString('command "param1 \'extra \"double double\"\'" param2').should eq(['command', 'param1 \'extra "double double"\'', 'param2'])
        end

    end

    describe '#initialize' do
        it 'should return cli-console instance' do
            console.should be_kind_of(CLI::Console)
        end
    end

    describe '#addCommand' do
        it 'should return array of command data' do
            commandData = [:test, 'short desc', 'long desc', 'usage']
            console.addCommand('test', *commandData).should eq(commandData)
        end
    end

    describe '#addExitCommand' do
        it 'should return array of exit command data' do
            commandData = [console.method(:end), 'exit', 'Exit from program', 'usage']
            console.addExitCommand('test', commandData[1], commandData[2], commandData[3]).should eq(commandData)
        end
    end

    describe '#addHelpCommand' do
        it 'should return array of help command data' do
            commandData = [console.method(:help), 'help', 'Help', 'usage']
            console.addHelpCommand('test', commandData[1], commandData[2], commandData[3]).should eq(commandData)
        end
    end

    describe '#addAlias' do
        it 'should return array of help command data' do
            commandData = ['command', 'short desc', 'long desc', 'usage']
            console.addAlias('alias', *commandData).should eq(commandData)
        end
    end

    describe '#usage' do
        it 'should display usage' do
            console.usage
            output.string.should eq("Type \"help\" to display available commands\n")
        end
    end

    describe '#processCommand' do
        before do
            init
        end

        it 'should return zero' do
            console.processCommand('').should eq(0)
        end

        it 'should be ambiguous command' do
            console.processCommand('tr').should eq(-3)
        end

        it 'should throw exception' do
            console.processCommand('try more').should eq(-1)
        end

        it 'should quit' do
            console.processCommand('q').should eq(console.ExitCode)
            console.processCommand('quit').should eq(console.ExitCode)
        end

        it 'should show help' do
            console.processCommand('help').should be_nil
            console.processCommand('help try').should be_nil
            console.processCommand('help e').should be_nil
        end

        it 'should show help for method and alias' do
            console.processCommand('help tr').should be_kind_of(Array)
        end

        it 'should execute succesfully' do
            console.processCommand('help not').should be_nil

        end
    end

    describe '#start' do
        def left
            'left'
        end

        it 'should start CLI' do
            input << "try lol\nnot found\nexit\n"
            input.rewind
            init
            console.start('%s> ',[method(:left)]).should eq(0)
            out = 'left>    CLI::CommandNotFoundError: lol
left>    Command "not" not recognized.
left> '

            output.string.should eq(out)
        end
    end

end

