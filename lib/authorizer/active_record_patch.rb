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
      symbol = action.to_sym
      perms = self.class.get_perms
      authorized = false
      authorized = perms[symbol].(self, authorizee) if perms[symbol]
      authorized ? self : nil
    end
  end
end