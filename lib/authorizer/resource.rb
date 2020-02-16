module Authorizer

    OPTIONS = [:authorize_associated, :behavior]

    POSSIBILITIES = [:allow_all, :deny_all, :filter]


    class Resource
        attr_reader :action, :actor, :resources, :options

        def initialize(action, actor, *resources, **options)
            @action = action
            @actor = actor
            @resources = resources
            @options = options
        end

        def get
            if @resources.count > 1
                behavior = options[:behavior]
                if !behavior
                    behavior = :allow_all
                end

                case behavior
                when :allow_all
                    behavior_allow_all
                when :deny_all
                    
                end
            else
                @resources[0].authorized?(@action, @actor)
            end
        end
    end

    private

    def behavior_allow_all
        results = @resources.map {|r| r.authorized?(@action, @actor)}
        filtered = results.compact
        results.count > 0 ? @resources : nil
    end

    def behavior_deny_all
        results = @resources.map {|r| r.authorized?(@action, @actor)}
        predicator = results.compact
        @resources.length == predicator.length ? @resources: nil
    end

    def behavior_filter
        results = @resources.filter {|r| r.authorized?(@action, @actor) != nil}
        results.length > 0 ? results : nil
    end
end