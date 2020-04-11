module ActionAuthorization
  class ActiveRecord::Base
    ##
    # This class contains all the patches to +ActiveRecord::Base+ that
    # make this library function on the model side. You should only
    # have to interact with these methods on concrete models and not by
    # interacting with ActiveRecord::Base directly.

    ##
    # returns the hash mapping permission rules to executable actions.
    # This is used internally and should not need to be called directly
    # by the user.
    def self.get_perms
      unless (self.class_variables.include?(:'@@perms'))
        @@perms = {}
      end
      init_fallback_rule
      return @@perms
    end
    
    ##
    # Ensures that the +@@fallback_rule+ variable is defined.
    # Used internally. There should be no need for users to call this method directly.
    def self.init_fallback_rule
      @@fallback_rule = nil unless (self.class_variable_defined?(:@@fallback_rule))
    end
    
    ##
    # Defines an authorization rule for the specified
    # action names. If multiple names are passed, then the same rule
    # will be used for all of them.
    # 
    # Action names should take the following format "controller_name#action_name".
    # E.G. To specify a rule for the update action on the posts controller, you would write
    # 'posts#update'.
    #
    # names can also be symbols.
    def self.define_rule(*names, &block)
      perms = self.get_perms
      names.each {|name| perms[name.to_sym] = block}
    end
    
    ##
    # Defins a fallback rule. The fallback rule defined by this
    # class method will be used in every case where a permission rule is not
    # specified. This is intended to be used in situations where 
    # users wish to define some generic authorization check that will be run for
    # every action that doesn't have its own rule specified.
    def self.set_fallback_rule(&rule)
      @@fallback_rule = rule
    end

    def is_authorized(action, authorizee)
      symbol = action.to_sym
      perms = self.class.get_perms

      authorized = false
      authorized = perms[symbol].(self, authorizee, symbol) if perms[symbol]
      authorized = @@fallback_rule.(self, authorizee) if @@fallback_rule && !perms[symbol]

      raise ForbiddenError.new(
        "Actor #{authorizee} is not authorized to perform action #{action} on resource #{self}."
      ) unless authorized

      self
    end
  end
end