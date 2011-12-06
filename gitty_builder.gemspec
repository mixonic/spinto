Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'gitty_builder'
  s.version           = '0.1.0'
  s.date              = '2011-12-06'

  s.summary     = "The site generator used at gitty."
  s.description = "Gitty Builder uses Jekyll and plugins to build static sites."

  s.authors  = ["Matthew Beale"]
  s.email    = 'matt.beale@madhatted.com'
  s.homepage = 'http://github.com/mixonic/gitty_builder'

  s.require_paths = %w[lib]

  s.executables = ["gitty_builder"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.textile LICENSE]

  s.add_runtime_dependency('jekyll', "0.11.0")
  s.add_runtime_dependency('coffee-script', "2.2.0")

  s.add_development_dependency('rake', "~> 0.9")
  s.add_development_dependency('rdoc', "~> 3.11")
  
  # = MANIFEST =
  s.files = %w[

  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
