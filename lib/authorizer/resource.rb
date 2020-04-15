module ActionAuthorization

    ##
    # This class represents a generic list of models that are about to
    # authorized.
    #
    # It is instantiated automatically by +ActionController::Metal#check_authorization+ and there
    # should be little need to instantiate it directly.
    class Resource
        ##
        # @return [String, Symbol] The action which +:actor+ is attempting to complete.
        # @return [Model] The model attempting authorization (usually a +User+).
        # @return The list of models being authorized.
        # @return The options which are being used for authorization.
        attr_reader :action, :actor, :resources, :options
  
        ##
        # Creates a new instance of +Resource+.
        #
        # @param action [String, Symbol] The name of the action being performed.
        # @param actor [Model] The model attempting authorization.
        # @param *resources [Model] The list of models being authorized.
        # @param **options Any additional options regarding the authorization options.
        def initialize(action, actor, *resources, **options)
            @action = action
            @actor = actor
            @resources = resources
            @options = options
        end
  
        ##
        # Returns the list of models passed into the constructor
        # if the list passes authorization, otherwise raises
        # +ForbiddenError+.
        # @returns The list of models being authorized.
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
                    r.is_authorized(@action, @actor) != nil
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