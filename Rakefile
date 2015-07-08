=begin
 
	PUT LICENCE HERE

=end

require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'
require 'rspec/core/rake_task'

spec = Gem::Specification.new do |gem|
	gem.name          = "configurable-enc"
	gem.version       = '0.1.0'
	gem.authors       = ["George McIntosh"]
	gem.email         = ["george@elevenware.com"]
	gem.summary       = %q{A Puppet ENC that releases config based on configuration}
	gem.description   = %q{Releases Puppet configuration for a node dependent on the condition of dependent nodes}
	gem.homepage      = "https://os.uk"
	gem.license       = "Apache License (2.0)"

	gem.files         = Dir['{bin,lib,man,test,spec}/**/*', 'Rakefile', 'README*', 'LICENSE*']
	gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
	gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
	gem.require_paths = ["lib"]

	gem.add_development_dependency "rake"
	gem.add_development_dependency "rspec"
	gem.add_development_dependency "rspec-mocks"
	gem.add_runtime_dependency "json", "~> 1.8.0"
end

Gem::PackageTask.new(spec) do |pkg|
	pkg.need_tar = true
end

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
  t.verbose = true
end

 RSpec::Core::RakeTask.new(:spec) 