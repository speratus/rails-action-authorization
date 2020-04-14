module ActionAuthorization
    OPTIONS = [:authorize_associated, :behavior]

    POSSIBILITIES = [:allow_all, :deny_all, :filter]

    ##
    # This class adds instance methods to base controller to increase the ease
    # with which authorization may be checked from controllers.
    class ActionController::Metal

        ##
        # This method checks the authorization of a given actor (authorizee) to 
        # complete the controller action for the specified resource.
        #
        # The resource can be a single model or a List of models. In the case of
        # a list of models, there are several options for dealing with list members
        # that fail authorization checks. The default option is +behavior: :filter+ which
        # will authorize the list but will hide all members of the list which fail
        # the authorization check. Other options are +:allow_all+ and +:deny_all+.
        # +:allow_all+ will permit the entire list and include even list members which
        # fail the authorization test. +:deny_all+, on the other, authorizes the list only
        # if all of its members pass the authorization check. Therefore, if any list member fails
        # the authorization check, the actor is forbidden from completing the action on the entire
        # list.
        #
        # @param resource either a model or a list of models for which the actor (authorizee) is 
        #   attempting to complete the controller action.
        # @param authorizee [Model] The actor (usually a +User+ model) attempting authorization.
        # @param **options An unspecified number of options. Currently the only supported key is
        #   +:behavior+ and the only supported actions are +:filter+, +:allow_all+, and +:deny_all+.
        def check_authorization(resource, authorizee, **options)
            action = "#{params[:controller]}##{action_name}"

            if resource.respond_to?(:length)
                return resource if resource.length == 0
                r = Resource.new(action, authorizee, *resource, **options)
                result = r.get
            else
                result = resource.is_authorized(action, authorizee)
            end

            result
        end
    end
end