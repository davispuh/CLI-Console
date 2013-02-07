module CLI
    module Task
        private
        @@__usage__ = {}
        @@__desc__ = {}

        def usage(usage)
            usage = [usage.to_s] unless usage.class == Array
            @usage = usage
        end

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

        def get_description(name)
            return @@__desc__[name] if @@__desc__.key?(name)
        end

        def get_usage(name)
            return @@__usage__[name] if @@__usage__.key?(name)
        end

    end
end
