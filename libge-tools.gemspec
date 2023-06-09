# frozen_string_literal: true

require_relative "lib/libge/tools/version"

Gem::Specification.new do |spec|
  spec.name = "libge-tools"
  spec.version = Libge::Tools::VERSION
  spec.authors = ["Alexander Feodorov"]
  spec.email = ["vester@unixcomp.org"]
  spec.license = 'LGPL-3.0'

  spec.summary = "Tools for Libge"
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://gitlab.com/libge/tools"
  spec.required_ruby_version = ">= 2.7.0"

  # mspec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/unixs/libge-tools"
  spec.metadata["changelog_uri"] = "https://github.com/unixs/libge-tools/blob/master/CHANGELOG.md"
  spec.metadata["github_repo"] = "ssh://github.com/unixs/libge-tools"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the
  # RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.executables << "libge-parser"
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "google_drive", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
