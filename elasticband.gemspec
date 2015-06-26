lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'elasticband/version'

Gem::Specification.new do |s|
  s.name        = 'elasticband'
  s.version     = Elasticband::VERSION
  s.platform    = Gem::Platform::RUBY

  s.date        = '2015-06-26'
  s.summary     = 'Query builder for elasticsearch-rails'
  s.homepage    = 'https://github.com/LoveMondays/elasticband'
  s.license     = 'MIT'

  s.authors     = ['Glauber Campinho', 'Rubens Minoru Andako Bueno']
  s.email       = ['ggcampinho@gmail.com', 'rubensmabueno@hotmail.com']
  s.files       = `git ls-files -z`.split("\x0")

  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.3.0'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'codeclimate-test-reporter'
end
