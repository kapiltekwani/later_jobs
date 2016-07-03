$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "later_jobs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "later_jobs"
  s.version     = LaterJobs::VERSION
  s.authors     = ["kapil Tekwani"]
  s.email       = ["kapiltekwani@gmail.com"]
  s.summary     = "Later job for scheduling background jobs"
  s.description = "Later job for scheduling background jobs"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4"

  # s.add_development_dependency "sqlite3"
end
