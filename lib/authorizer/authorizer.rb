# require_relative './railtie'

module Authorizer
    class ActiveRecord::Base
        def self.get_perms
            unless (self.class_variables.include?(:'@@perms'))
              @@perms = {}
            end
            return @@perms
          end
        
          def self.check_perm(name, &block)
            perms = self.get_perms
            perms[name.to_sym] = block
          end
        
          def self.authorized?(action, resource, authorizee)
            perms = self.get_perms
            authorized = false
            authorized = perms[action.to_sym].(resource, authorizee) if perms[action.to_sym]
            authorized ? resource : nil
          end
    end

    class ActionController::Metal
        def check_authorization(resource, authorizee)
            resource.class.authorized?("#{params[:controller]}##{action_name}", resource, authorizee)
        end
    end


    # module ModelClassMethods
    #     def self.get_perms
    #         unless (self.class_variables.include?(:'@@perms'))
    #           @@perms = {}
    #         end
    #         return @@perms
    #       end
        
    #       def self.check_perm(name, &block)
    #         perms = self.get_perms
    #         perms[name.to_sym] = block
    #       end
        
    #       def self.authorized?(action, resource, authorizee)
    #         perms = self.get_perms
    #         authorized = false
    #         authorized = perms[action.to_sym].(resource, authorizee) if perms[action]
    #         authorized ? resource : nil
    #       end
    # end
    # module ControllerMethods
    #     def check_authorization(resource, authorizee)
    #         resource.class.authorized?("#{params[:controller]}##{action_name}", resource, authorizee)
    #     end
    # end
end