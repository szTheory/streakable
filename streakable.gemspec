# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'streakable'
  spec.version       = '0.1.0'
  spec.authors       = ['szTheory', 'Garrett Martin']
  spec.email         = ['szTheory@github.com']
  spec.description   = %q{Track consecutive day streaks on ActiveRecord models.}
  spec.summary       = %q{Easily track consecutive day streaks on your Rails/ActiveRecord models.}
  spec.homepage      = 'https://github.com/szTheory/streakable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 2.0'

  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
  spec.add_development_dependency 'rspec', '~> 3.8', '>= 3.8.0'
  spec.add_development_dependency 'database_cleaner', '~> 1.7.0', '>= 1.7.0'
  spec.add_development_dependency 'bundler', '~> 1.3', '>= 1.3'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.1'
  spec.add_development_dependency 'pry', '~> 0.11', '>= 0.11.3'
  spec.add_development_dependency 'timecop', '~> 0.9', '>= 0.9.1'
end
