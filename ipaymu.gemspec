$:.push File.expand_path("../lib", __FILE__)
require "ipaymu/version"

Gem::Specification.new do |s|
  s.name = "ipaymu"
  s.summary = "ipaymu Ruby Server SDK"
  s.description = "Resources and tools for developers to integrate ipaymu's payments platform."
  s.version = ipaymu::Version::String
  s.license = "MIT"
  s.author = "adi gunawan"
  s.email = "code@getipaymu.com"
  s.homepage = "https://www.ipaymu.com/"
  s.files = Dir.glob ["README.rdoc", "LICENSE", "lib/**/*.{rb,crt}", "spec/**/*", "*.gemspec"]
  s.add_dependency "builder", ">= 3.2.4"
  s.add_dependency "rexml", ">= 3.1.9" # Use rexml version associated with minimum supported Ruby version
  s.required_ruby_version = ">=2.6.0"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/zgunz42/ipaymu_ruby/issues",
    "changelog_uri" => "https://github.com/zgunz42/ipaymu_ruby/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/zgunz42/ipaymu_ruby",
    "documentation_uri" => "https://ipaymu.com/"
  }
end