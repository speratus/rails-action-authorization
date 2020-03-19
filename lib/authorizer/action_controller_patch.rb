module Authorizer
    OPTIONS = [:authorize_associated, :behavior]

    POSSIBILITIES = [:allow_all, :deny_all, :filter]

    class ActionController::Metal
        def check_authorization(resource, authorizee, **options)
            action = "#{params[:controller]}##{action_name}"

            if resource.respond_to?(:length)
            return resource if resource.length == 0
            r = Resource.new(action, authorizee, *resource, **options)
            result = r.get
            else
            result = resource.authorized?(action, authorizee)
            end

            if result
            result
            else
            render json: {message: 'You are not permitted to access that resource'}, status: 403
            return
            end
        end
    end
end