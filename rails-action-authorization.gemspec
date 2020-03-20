$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "authorizer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rails-action-authorization"
  spec.version     = ActionAuthorization::VERSION
  spec.authors     = ["Andrew Luchuk"]
  spec.email       = ["andrew.luchuk@outlook.com"]
  # spec.homepage    = "TODO"
  spec.summary     = "Adds a custom authorization system to rails"
  spec.description = "Adds a custom authorization system to Rails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.1"

  spec.add_development_dependency "sqlite3"
end
