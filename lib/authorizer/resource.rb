module ActionAuthorization
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
              behavior = :filter
          end
  
          case behavior
          when :allow_all
              collect_permitted(return_res: true) {|results| results.length > 0}
          when :deny_all
              collect_permitted {|results| results.length == @resources.length}
          when :filter
              collect_permitted {|results| results.length > 0}
          end
        end
  
        private

        def collect_permitted(return_res: false)
            results = @resources.filter do |r|
                begin
                    r.authorized?(@action, @actor) != nil
                rescue
                    false
                end
            end

            unless yield(results)
                raise ForbiddenError
            end
            return @resources if return_res
            results
        end
    end
end