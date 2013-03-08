require 'cli-console/version'
require 'cli-console/task'


# Command-line interface module
module CLI
    # Console class
    #
    # ```ruby
    #   # io some input/output class (like HighLine)
    #   console = CLI::Console.new(io)
    # ```
    class Console
        def initialize(io)
            @Commands = {}
            @Aliases = {}
            @IO = io
            @Seperator = '-'
            @SepCount = 30
            @Backtrace = false
            @Partial = true
            @ExitCode = -100
            @UseReadline = true
        end

        protected

        # Outputs nicely formated exception
        # displays backtrace if @Backtrace
        # @param exception [Exception] exception to display
        def showException(exception)
            @IO.say "Exception: #{exception.message.strip}"
            if @Backtrace
                @IO.say 'Backtrace:'
                @IO.indent do |io|
                    exception.backtrace.each do |b|
                        io.say b
                    end
                end
            end
        end

        public
        attr_accessor :Partial
        attr_accessor :ExitCode
        attr_accessor :Seperator
        attr_accessor :SepCount
        attr_accessor :Backtrace
        attr_accessor :UseReadline

        # Adds command
        # @param commandName [String] name of command
        # @param command [Method] command method
        # @param commandDescription [String] short description about command
        # @param commandLongDescription [String] long description about command
        # @param commandUsage [String] usage information about command
        # @return [Array] command information
        def addCommand(commandName, command, commandDescription='', commandLongDescription = nil, commandUsage = nil)
            commandLongDescription = command.owner.get_description(command.name) if commandLongDescription == nil
            commandUsage = command.owner.get_usage(command.name) if commandUsage == nil
            @Commands[commandName] = [command, commandDescription, commandLongDescription, commandUsage]
        end

        # Adds name for exit command
        # @param commandName [String] name of exit command
        # @param commandDescription [String] short description about command
        # @param commandLongDescription [String] long description about command
        # @param commandUsage [String] usage information about command
        # @return [Array] command information
        def addExitCommand(commandName, commandDescription='', commandLongDescription = nil, commandUsage = nil)
            commandLongDescription = 'Exit...' unless commandLongDescription
            commandUsage = ['exit'] unless commandUsage
            @Commands[commandName] = [method(:end), commandDescription, commandLongDescription, commandUsage]
        end

        # Adds name for help command
        # @param commandName [String] name of exit command
        # @param commandDescription [String] short description about command
        # @param commandLongDescription [String] long description about command
        # @param commandUsage [String] usage information about command
        # @return [Array] command information
        def addHelpCommand(commandName, commandDescription='', commandLongDescription = nil, commandUsage = nil)
            commandLongDescription = 'Display Help for <command>' unless commandLongDescription
            commandUsage = ['help <command>'] unless commandUsage
            @Commands[commandName] = [method(:help), commandDescription, commandLongDescription, commandUsage]
        end

        # Adds alias for command
        # @param aliasName [String] name of for alias
        # @param commandNameParms [String] command to alias
        # @param commandDescription [String] short description about alias
        # @param commandLongDescription [String] long description about alias
        # @param commandUsage [String] usage information about alias
        # @return [Array] alias information
        def addAlias(aliasName, commandNameParms, commandDescription=nil, commandLongDescription = nil, commandUsage = nil)
            @Aliases[aliasName] = [commandNameParms, commandDescription, commandLongDescription, commandUsage]
        end

        # Waits till user enters command
        # @param inputText [String] text to show to user
        # @return [String] entered command
        def getCommand(inputText)
            @LastCommand = @IO.ask(inputText) do |h|
                h.whitespace = :strip_and_collapse
                h.validate = nil
                h.readline = @UseReadline
                h.completion = @Commands.keys+@Aliases.keys
            end
            @LastCommand = '' if (not @LastCommand.to_s.empty? and @LastCommand[0] == '#')
            return @LastCommand
        end

        # @param command [String]
        # @return [Array]
        def commandMatch(command)
            matches = []
            commandStrings = @Commands.merge(@Aliases)
            commandStrings.each do |key, value|
                matches.push([key, value]) if (@Partial and key.start_with?(command)) or key == command
            end
            matches
        end

        # displays matched commands
        # @param matches [Array]
        def showMatches(matches)
            @IO.say('Matches:')
            matches.each do |value|
                text = value[0].to_s
                text += ' - '+value[1][1].to_s unless value[1][1].to_s.empty?
                @IO.indent(1, text )
            end
        end

        # Executes command with parameters
        # @param commandString [String]
        # @return command result or error number
        def processCommand(commandString)
            return 0 if commandString.to_s.empty?
            commandWords = []
            commandString.scan(/([^\s"']+)|"([^"]*)"|'([^']*)'/) do |m|
                commandWords << m[0] unless m[0].nil?
                commandWords << m[1] unless m[1].nil?
                commandWords << m[2] unless m[2].nil?
            end
            command = commandWords.shift.downcase

            if (not @Commands.key?(command) and not @Aliases.key?(command))
                matches = commandMatch(command)
                if matches.length == 1
                    if matches[0][1][0].class == String
                        oldCommandWords = [matches[0][1][0]]
                    commandWords = @Aliases[matches[0][0]][0].split
                    command = commandWords.shift.downcase
                    commandWords += oldCommandWords
                    else
                    command = matches[0][0]
                    end
                elsif matches.length > 0
                    @IO.say('Ambiguous command.')
                    showMatches(matches)
                return -3
                else
                    @IO.say("Command \"#{command}\" not recognized.")
                return -2
                end
            elsif @Aliases.key?(command)
            oldCommandWords = commandWords
            commandWords = @Aliases[command][0].split
            command = commandWords.shift.downcase
            commandWords += oldCommandWords
            end
            begin
                return @Commands[command][0].call(commandWords)
            rescue Exception => e
                showException(e)
            end
            return -1
        end

        # Starts main CLI loop, waits for user input
        # @param formatString [String]
        # @param formatValues [Array]
        # @return [Fixnum]
        def start(formatString, formatValues)
            indent_level = @IO.indent_level
            loop do
                begin
                    currentValues = []
                    formatValues.each do |value|
                        if value.respond_to?("call")
                        currentValues.push(value.call)
                        else
                        currentValues.push(value)
                        end
                    end
                    command = getCommand( formatString % currentValues )
                    @IO.indent_level+=1
                    result = processCommand(command)
                    @IO.indent_level-=1
                    return 0 if result == @ExitCode
                rescue Exception => e
                    showException(e)
                @IO.indent_level=indent_level
                end
            end
            -1
        end

        # Displays seperator line
        def printSeperator
            @IO.say(@Seperator*@SepCount)
        end

        # Displays help about command
        # @param command [String] command for which display help
        def commandHelp(command)
            if @Commands.key?(command)
                printSeperator
                if not @Commands[command][3].to_a.empty?
                    @IO.indent do |io|
                        @Commands[command][3].each { |c| io.say c}
                        io.newline
                    end
                end
                @IO.say(@Commands[command][2]) unless @Commands[command][2].to_s.empty?
                printSeperator
            end
        end

        # Displays usage
        def usage
            @IO.say('Type "help" to display available commands')
        end

        # Shows message to inform how to get more information about command
        # @param helpCommand [String] command for which display message
        def command_usage(helpCommand='help')
            @IO.say("You can type \"#{helpCommand} <command>\" for more info")
        end

        # Shows help information about command
        # @param params [Array] command for which show help
        def help(params=[])
            if not params.to_a.empty?
                command = params[0].downcase
                if (not @Commands.key?(command) and not @Aliases.key?(command))
                    matches = commandMatch command
                    if (matches.length == 1)
                        commandHelp(matches[0][0])
                    elsif matches.length > 0
                        @IO.say('Help for ambiguous command.')
                        showMatches matches
                    else
                        @IO.say("Help for command \"#{params[0]}\" not found!")
                    end
                elsif @Aliases.key?(command)
                    if not @Aliases[command][2].to_s.empty?
                    @IO.say(@Aliases[command][2])
                    else
                        commandHelp(@Aliases[command][0].split()[0])
                    end
                else
                    commandHelp(command)
                end
            else
                helpCommand = 'help'
                printSeperator
                @IO.indent do |io|
                    @Commands.each do |key,value|
                        if (value[0].name != 'help')
                            helpText = key
                            if (not value[1].to_s.empty?)
                                helpText += ' - '+value[1]
                            end
                        io.say(helpText)
                        else
                        helpCommand = value[0].name
                        end
                    end
                    @Aliases.each do |key, value|
                        helpText = key
                        if (not value[1].to_s.empty?)
                            helpText += ' - '+value[1]
                        else
                            helpText += ' - alias to "'+value[0]+'"'
                        end
                        io.say(helpText)
                    end
                end
                command_usage(helpCommand)
                printSeperator
            end
        end

        # @param params [Array] unused
        # @return [Fixnum]
        def end(params=[])
            @ExitCode
        end
    end
end
