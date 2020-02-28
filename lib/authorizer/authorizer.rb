# require_relative './railtie'

module Authorizer
  OPTIONS = [:authorize_associated, :behavior]

  POSSIBILITIES = [:allow_all, :deny_all, :filter]
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
    def check_authorization(resource, authorizee, **options)
      action = "#{params[:controller]}##{action_name}"

      if resource.respond_to?(:length)
        byebug
        r = Resource.new(action, authorizee, *resource, **options)
      else
        byebug
        r = Resource.new(action, authorizee, resource, **options)
      end

      result = r.get
      if result
        result
      else
        render json: {message: 'You are not permitted to access that resource'}, status: 403
      end
    end
  end

  class Resource
      attr_reader :action, :actor, :resources, :options

      def initialize(action, actor, *resources, **options)
          byebug
          @action = action
          @actor = actor
          @resources = resources
          @options = options
      end

      def get
          if @resources.length > 1

              behavior = options[:behavior]
              if !behavior
                  behavior = :allow_all
              end

              case behavior
              when :allow_all
                  behavior_allow_all
              when :deny_all
                  behavior_deny_all
              when :filter
                  behavior_filter
              end
          else
              @resources[0].authorized?(@action, @actor)
          end
      end

      private
    
      def behavior_allow_all
          results = @resources.map {|r| r.authorized?(@action, @actor)}
          filtered = results.compact
          results.count > 0 ? @resources : nil
      end
    
      def behavior_deny_all
          results = @resources.map {|r| r.authorized?(@action, @actor)}
          predicator = results.compact
          @resources.length == predicator.length ? @resources: nil
      end
    
      def behavior_filter
          results = @resources.filter {|r| r.authorized?(@action, @actor) != nil}
          results.length > 0 ? results : nil
      end
  end

end