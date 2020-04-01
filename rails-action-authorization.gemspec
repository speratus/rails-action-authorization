$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "authorizer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rails-action-authorization"
  spec.version     = ActionAuthorization::VERSION
  spec.authors     = ["Andrew Luchuk"]
  spec.email       = ["andrew.luchuk@outlook.com"]
  spec.homepage    = "https://github.com/speratus/rails-action-authorization"
  spec.summary     = "Rails Action Authorization adds an authorization framework for controller actions."
  spec.description = "Rails Action Authorization adds an authorization framework for controller actions. "\
                     "Rails Action Authorization is designed to be extremely lightweight and flexible, "\
                     "enabling developers to spend less time trying to build complex authorization systems. "\
                     "It\'s unopinionated design makes it easy to define any kind of authorization rules with "\
                     "minimal effort."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.1"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'codecov'
end
