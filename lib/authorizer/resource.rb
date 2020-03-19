module Authorizer
    class Resource
        attr_reader :action, :actor, :resources, :options
  
        def initialize(action, actor, *resources, **options)
            @action = action
            @actor = actor
            @resources = resources
            @options = options
        end
  
        def get
          return @resources if @resources.nil?
          return @resources if @resources.length == 0
  
          behavior = @options[:behavior]
          if !behavior
              behavior = :allow_all
          end
  
          case behavior
          when :allow_all
              behavior_allow_all
          when :deny_all
              behavior_deny_all
          when :filter
              behavior_filter
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
            results = @resources.filter do |r| 
                begin
                    r.authorized?(@action, @actor) != nil
                    r
                rescue Authorizer::ForbiddenError
                    false
                end
            end
            results.length > 0 ? results : nil
        end
    end
end