# require_relative './railtie'

module Authorizer
    class ActiveRecord::Base
        def self.get_perms
            unless (self.class_variables.include?(:'@@perms'))
              @@perms = {}
            end
            return @@perms
          end
        
          def self.check_perm(*names, &block)
            perms = self.get_perms
            names.each {|name| perms[name.to_sym] = block}
          end
        
          def authorized?(action, authorizee)
            perms = self.class.get_perms
            authorized = false
            authorized = perms[action.to_sym].(self, authorizee) if perms[action.to_sym]
            authorized ? self : nil
          end
    end

    class ActionController::Metal
        def check_authorization(resource, authorizee)
            result = resource.class.authorized?("#{params[:controller]}##{action_name}", resource, authorizee)
            if result
              result
            else
              render json: {message: 'You are not permitted to access that resource'}, status: 403
            end
        end
    end
end