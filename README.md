README for raptget
==================

Raptget is a gem providing a ruby interface to the apt-get package manager.

To install, type 'gem install raptget'

Usage:

```ruby
  require 'raptget'
  include Raptget

  packages = Array.new
  packages.push('iagno')
  packages.push('gnome-games')

  aptget = Aptget.new
  aptget.install(packages)
```