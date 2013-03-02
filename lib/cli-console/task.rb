module CLI
    # Task module which must be included in class which provides commands
    #
    # Example:
    #
    # ```ruby
    #   class UI
    #     extend CLI::Task
    #
    #     usage 'Usage: command'
    #     desc 'command desciption'
    #
    #     def command(params)
    #     end
    #
    #   end
    # ```
    module Task
        private
        @@__usage__ = {}
        @@__desc__ = {}

        # sets usage for command
        # @param usage [String]
        # @return @usage
        def usage(usage)
            usage = [usage.to_s] unless usage.class == Array
            @usage = usage
        end

        # sets description for command
        # @param desc [String] description
        # @return @desc
        def desc(desc)
            @desc = desc
        end

        def method_added(method)
            name = method.to_s
            return unless name != 'initialize' and (public_instance_methods.include?(name) or public_instance_methods.include?(name.to_sym))
            @@__desc__[method]=@desc unless @@__desc__.key?(method)
            @@__usage__[method]=@usage unless @@__usage__.key?(method)
            @desc = nil
            @usage = nil
        end

        public

        # description for command
        # @param name [String] name of command
        # @return [String] description
        def get_description(name)
            return @@__desc__[name] if @@__desc__.key?(name)
        end

        # usage information for command
        # @param name [String] name of command
        # @return [String] usage
        def get_usage(name)
            return @@__usage__[name] if @@__usage__.key?(name)
        end

    end
end
