module Authorizer
  class ActiveRecord::Base
    def self.get_perms
      unless (self.class_variables.include?(:'@@perms'))
        @@perms = {}
        @@fallback_rule = nil
      end
      return @@perms
    end

    def self.check_perm(*names, &block)
      perms = self.get_perms
      names.each {|name| perms[name.to_sym] = block}
    end

    def self.set_fallback_rule(&rule)
      @@fallback_rule = rule
    end

    def authorized?(action, authorizee)
      symbol = action.to_sym
      perms = self.class.get_perms

      authorized = false
      authorized = perms[symbol].(self, authorizee) if perms[symbol]
      authorized = @@fallback_rule.(self, authorizee) if @@fallback_rule && !perms[symbol]

      raise ForbiddenError.new(
        "Actor #{authorizee} is not authorized to perform action #{action} on resource #{self}."
      ) unless authorized

      self
    end
  end
end