require_relative './authorizer.rb'

module Authorizer
  class Railtie < ::Rails::Railtie
    # ActiveRecord::Base.include Authorizer::ModelClassMethods
    # ActionController::API.include Authorizer::ControllerMethods
  end
end
