require_relative 'lib/raptget/version'

Gem::Specification.new do |s|
  s.name = %q{raptget}
  s.version = Raptget::VERSION::STRING
  s.date = Time.now
  s.authors = ["Joel Bryan Juliano"]
  s.email = %q{joelbryan.juliano@gmail.com}
  s.summary = %q{Apt-Get Package Manager for Ruby}
  s.homepage = %q{http://github.com/jjuliano/raptget}
  s.description = %q{A gem providing a ruby interface to the apt-get package manager.}
  s.files = [ "README.md", "Changelog", "LICENSE", "setup.rb",
              "lib/raptget.rb", "lib/raptget/version.rb", "test/test_raptget.rb",
              "test/test_helper.rb" ]
  s.license = "GNU LGPLv3"
end
