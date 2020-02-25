require_relative 'lib/flattenator/version'

Gem::Specification.new do |spec|
  spec.name          = "flattenator"
  spec.version       = Flattenator::VERSION
  spec.authors       = ["Patrick Byrne"]
  spec.email         = ["34053+pbyrne@users.noreply.github.com"]

  spec.summary       = %q{Flatten deeply nested hashes.}
  spec.homepage      = "https://github.com/pbyrne/flattenator"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.markdown"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]
end
