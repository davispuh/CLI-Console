require 'spec_helper'


class UI
    private
    extend CLI::Task

    public

    usage 'Usage: try'
    desc 'try exception'
    def try(params)
        raise Exception, params[0]
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
        it 'should execute succesfully' do
            init
            console.processCommand('tr')
            console.processCommand('try more')
            console.processCommand('q')
            console.processCommand('quit')
            console.processCommand('help')
            console.processCommand('help tr')
            console.processCommand('help try')
            console.processCommand('help not')
            console.processCommand('help e')
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
            out = 'left>    Exception: lol
left>    Command "not" not recognized.
left> '

            output.string.should eq(out)
        end
    end

end

