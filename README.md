RaptGet - Apt-Get Package Manager for Ruby
==========================================

Raptget is a gem providing a ruby interface to the apt-get package manager.

To install, type 'gem install raptget'

### Why RaptGet?

RaptGet creates simple and small development tools that help you design,
develop, deploy cloud infrastractures for your enterprise software systems.

#### RaptGet Pro: A Commercial, Supported Version of RaptGet
RaptGet Pro is a collection of useful functionality for the open source RaptGet library with priority support via Remote access or Skype from the author, new features in-demand, upgrades and lots more.

Sales of RaptGet Pro also benefit the community by ensuring that RaptGet itself will remain well supported for the foreseeable future.

#### Licensing
RaptGet is available under the terms of the GNU LGPLv3 license.

In addition to its useful functionality, buying RaptGet Pro grants your organization a RaptGet Commercial License instead of the GNU LGPL, avoiding any legal issues your lawyers might raise. Please contact joelbryan AT me.com for further detail on licensing including options for embedding RaptGet Pro in your own products.

#### Buy RaptGet Pro
Contact me via joelbryan.juliano@gmail.com,
and Pay via Paypal: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=72VVRU869SUB6

# Usage
Usage:

```ruby
  require 'raptget'
  include Raptget

  packages = ['iagno', 'gnome-games']
  aptget = Aptget.new
  aptget.download_only = true # See options
  aptget.install(packages)
```

Options:

```ruby
  aptget = Aptget.new

  # Download only; package files are only retrieved,
  # not unpacked or installed.
  # Configuration Item: APT::Get::Download-Only.
  #
  aptget.download_only = true

  #
  # Fix; attempt to correct a system with broken dependencies
  # in place. This option, when used with install/remove,
  # can omit any packages to permit APT to deduce a likely solution.
  # Any Package that are specified must completely correct the problem.
  # The option is sometimes necessary when running APT for the first time;
  # APT itself does not allow broken package dependencies to exist
  # on a system. It is possible that a system's dependency structure can be
  # so corrupt as to require manual intervention (which usually means using
  # dselect or 'remove' to eliminate some of the offending packages).
  # Use of this option together with 'fix_missing' may produce
  # an error in some situations.
  # Configuration Item: APT::Get::Fix-Broken.
  #
  aptget.fix_broken = true

  #
  # Ignore missing packages; If packages cannot be retrieved or fail the
  # integrity check after retrieval (corrupted package files), hold back
  # those packages and handle the result. Use of this option together
  # with 'fix_broken' may produce an error in some
  # situations. If a package is selected for installation
  # (particularly if it is mentioned on the command line) and it could not be
  # downloaded then it will be silently held back.
  # Configuration Item: APT::Get::Fix-Missing.
  #
  aptget.fix_missing = true

  #
  # Alias to fix_missing
  #
  aptget.ignore_missing = true

  #
  # Disables downloading of packages.
  # This is best used with ignore_missing to force APT
  # to use only the .debs it has already downloaded.
  # Configuration Item: APT::Get::Download.
  #
  aptget.no_download = true

  #
  # Quiet; produces output suitable for logging, omitting progress
  # indicators. You can also use 'quiet=#' to set the quiet level,
  # overriding the configuration file. Note that quiet level 2 implies 'yes',
  # you should never use 'quiet=2' without a no-action modifier
  # such as 'download_only', 'print_uris' or 'simulate' as APT may decided to
  # do something you did not expect.
  # Configuration Item: quiet.
  #
  aptget.quiet = true

  #
  # No action; perform a simulation of events that would occur
  # but do not actually change the system.
  # Configuration Item: APT::Get::Simulate.
  # Simulate prints out a series of lines each one representing a
  # dpkg operation, Configure (Conf), Remove (Remv), Unpack (Inst).
  # Square brackets indicate broken packages with and empty set of square
  # brackets meaning breaks that are of no consequence (rare).
  #
  aptget.simulate = true

  #
  # Alias to simulate
  #
  aptget.just_print = true

  #
  # Alias to simulate
  #
  aptget.dry_run = true

  #
  # Alias to simulate
  #
  aptget.recon = true

  #
  # Alias to simulate
  #
  aptget.no_act = true

  #
  # Automatic yes to prompts; assume "yes" as answer to all
  # prompts and run non-interactively. If an undesirable situation,
  # such as changing a held package or removing an essential package
  # occurs then apt-get will abort.
  # Configuration Item: APT::Get::Assume-Yes.
  #
  aptget.assume_yes = true

  #
  # Alias to assume_yes
  #
  aptget.yes = true

  #
  # Show upgraded packages; Print out a list of all packages
  # that are to be upgraded.
  # Configuration Item: APT::Get::Show-Upgraded.
  #
  aptget.show_upgraded = true

  #
  # Show full versions for upgraded and installed packages.
  # Configuration Item: APT::Get::Show-Versions.
  #
  aptget.verbose_version = true

  #
  # Compile source packages after downloading them.
  # Configuration Item: APT::Get::Compile.
  #
  aptget.build = true

  #
  # Alias to build
  #
  aptget.compile = true

  #
  # Also install recommended packages.
  #
  aptget.install_recommends = true

  #
  # Do not install recommended packages.
  #
  aptget.no_install_recommends = true

  #
  # Ignore package Holds; This causes apt-get to ignore a
  # hold placed on a package.
  # This may be useful in conjunction with dist-upgrade
  # to override a large number of undesired holds.
  # Configuration Item: APT::Ignore-Hold.
  #
  aptget.ignore_hold = true

  #
  # Do not upgrade packages; When used in conjunction with
  # install no-upgrade will prevent packages listed from being
  # upgraded if they are already installed.
  # Configuration Item: APT::Get::Upgrade.
  #
  aptget.no_upgrade = true

  #
  # Force yes; This is a dangerous option that will cause
  # apt to continue without prompting if it is doing something
  # potentially harmful. It should not be used except in very special
  # situations. Using 'force_yes' can potentially destroy your system!
  # Configuration Item: APT::Get::force-yes.
  #
  aptget.force_yes = true

  #
  # Instead of fetching the files to install their URIs are printed.
  # Each URI will have the path, the destination file name, the size
  # and the expected md5 hash. Note that the file name to write to will
  # not always match the file name on the remote site!
  # This also works with the source and update commands.
  # When used with the update command the MD5 and size are not included,
  # and it is up to the user to decompress any compressed files.
  # Configuration Item: APT::Get::Print-URIs.
  #
  aptget.print_uris = true

  #
  # Use purge instead of remove for anything that would be removed.
  # An asterisk ("*") will be displayed next to packages which are
  # scheduled to be purged.
  # Configuration Item: APT::Get::Purge.
  #
  aptget.purge = true

  #
  # Re-Install packages that are already installed and at the
  # newest version.
  # Configuration Item: APT::Get::ReInstall.
  #
  aptget.reinstall = true

  #
  # This option defaults to on, use 'no_list_cleanup' to turn it off.
  # When on apt-get will automatically manage the contents of
  # /var/lib/apt/lists to ensure that obsolete files are erased.
  # The only reason to turn it off is if you frequently change your
  # source list.
  # Configuration Item: APT::Get::List-Cleanup.
  #
  aptget.list_cleanup = true

  #
  # This option controls the default input to the policy engine,
  # it creates a default pin at priority 990 using the specified
  # release string. The preferences file may further override this setting.
  # In short, this option lets you have simple control over which
  # distribution packages will be retrieved from.
  # Some common examples might be 'default_release = 2.1*' or
  # 'default_release = unstable'.
  # Configuration Item: APT::Default-Release;
  #
  aptget.default_release = true

  #
  # Alias to default_release
  #
  aptget.target_release = true

  #
  # Only perform operations that are 'trivial'. Logically this can
  # be considered related to 'assume_yes', where 'assume_yes' will
  # answer yes to any prompt, 'trivial_only' will answer no.
  # Configuration Item: APT::Get::Trivial-Only.
  #
  aptget.trivial_only = true

  #
  # If any packages are to be removed apt-get immediately aborts
  # without prompting.
  # Configuration Item: APT::Get::Remove
  #
  aptget.no_remove = true

  #
  # If the command is either install or remove, then this option acts
  # like running autoremove command, removing the unused dependency
  # packages.
  # Configuration Item: APT::Get::AutomaticRemove.
  #
  aptget.auto_remove = true

  #
  # Only has meaning for the source command.
  # Indicates that the given source names are not to be mapped
  # through the binary table. This means that if this option is specified,
  # the source command will only accept source package names as arguments,
  # rather than accepting binary package names and looking up the
  # corresponding source package.
  # Configuration Item: APT::Get::Only-Source
  #
  aptget.only_source = true

  #
  # Download only the tar file of a source archive.
  # Configuration Item: APT::Get::Tar-Only
  #
  aptget.tar_only = true

  #
  # Download only the dsc file of a source archive.
  # Configuration Item: APT::Get::Dsc-Only
  #
  aptget.dsc_only = true

  #
  # Download only the diff file of a source archive.
  # Configuration Item: APT::Get::Diff-Only
  #
  aptget.diff_only = true

  #
  # Ignore if packages can't be authenticated and don't prompt about
  # it. This is useful for tools like pbuilder.
  # Configuration Item: APT::Get::AllowUnauthenticated.
  #
  aptget.allow_unauthenticated = true

  #
  # Only process architecture-dependent build-dependencies.
  # Configuration Item: APT::Get::Arch-Only
  #
  aptget.arch_only = true

  #
  # Configuration File; Specify a configuration file to use.
  # The program will read the default configuration file and
  # then this configuration file.
  #
  aptget.config_file = true

  #
  # Set a Configuration Option; This will set an arbitrary
  # configuration option.
  # The syntax is raptget.option = "Foo::Bar=bar"
  #
  aptget.option = true

  #
  # Disable sudo. If this is not set, sudo
  # is used.
  #
  aptget.disable_sudo = true

  aptget.install(packages)
```

### Donations
Please support independent cloud computing toolkits, also money donated to the project will benefit the community by ensuring
that RaptGet itself will remain well supported for the foreseeable future.
To Donate, please visit: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KT9CY4T7BYDM4

