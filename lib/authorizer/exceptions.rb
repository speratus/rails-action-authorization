module Authorizer
    class AuthorizationError < ::StandardError

    end

    class ForbiddenError < AuthorizationError
        
    end
end