$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "govuk_rails_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "govuk_rails_engine"
  s.version     = GovukRailsEngine::VERSION
  s.authors     = ["GOV.UK Dev"]
  s.email       = ["govuk-dev@digital.cabinet-office.gov.uk"]
  s.summary     = "Layout engine for GOV.UK Rails applications"
  s.description = "Layout engine for GOV.UK Rails applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0"
  s.add_dependency "govuk_template", "~> 0.22"
  s.add_dependency "govuk_frontend_toolkit", "~> 6.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "govuk_schemas", "~> 2.1"
  s.add_development_dependency "minitest-rails", "~> 3.0"
  s.add_development_dependency "minitest-spec-rails", "~> 5.4"
end
