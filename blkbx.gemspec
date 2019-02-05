lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blkbx/version'

Gem::Specification.new do |spec|
  spec.name          = 'blkbx'
  spec.version       = Blkbx::VERSION
  spec.authors       = ['maccracken']
  spec.email         = ['robert.maccracken@gmail.com']
  spec.license       = 'Nonstandard'
  spec.summary       = 'Ruby-Watir-BlackBox'
  spec.description   = 'Description Here'
  spec.homepage      = 'https://valencemedia.com'
  spec.require_paths = ['lib']

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    tests = %r{^(test|spec|features)/}
    `git ls-files -z`.split("\x0").reject { |f| f.match(tests) }
  end

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.63'
end
