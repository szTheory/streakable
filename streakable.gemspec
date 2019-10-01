# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'streakable'
  spec.version       = '0.2.0'
  spec.authors       = ['szTheory', 'Garrett Martin']
  spec.description   = %q{Track consecutive day streaks on Rails/ActiveRecord models.}
  spec.summary       = %q{Easily track consecutive day streaks on your Rails/ActiveRecord model associations for a given date column.}
  spec.homepage      = 'https://sztheory.github.io/streakable/'
  spec.license       = 'MIT'
  spec.metadata = {
    "source_code_uri"   => "https://github.com/szTheory/streakable",
  }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 3.2.22'

  spec.add_development_dependency 'appraisal', '~> 2.2', '>= 2.2.0'
  spec.add_development_dependency 'bundler', '>= 1.3', '>= 1.3'
  spec.add_development_dependency 'coveralls', '~> 0.8', '>= 0.8.22'
  spec.add_development_dependency 'database_cleaner', '~> 1.7.0', '>= 1.7.0'
  spec.add_development_dependency 'pry', '~> 0.11', '>= 0.11.3'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.1'
  spec.add_development_dependency 'rspec', '~> 3.8', '>= 3.8.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
  spec.add_development_dependency 'timecop', '~> 0.9', '>= 0.9.1'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'pry-coolline'
end
