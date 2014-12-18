  # = raptget - A apt-get gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/raptget
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011-2015 Joel Bryan Juliano
  # License::   GNU LGPLv3
  #
  # class Raptget::Package.new( array, str, array)

  require 'tempfile'
  require_relative 'raptget/version'

  module Raptget
    class Aptget
      VERSION = Raptget::VERSION::STRING

      #
      # All accessors are boolean unless otherwise noted.
      #

      #
      # Download only; package files are only retrieved,
      # not unpacked or installed.
      # Configuration Item: APT::Get::Download-Only.
      #
      attr_accessor :download_only

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
      attr_accessor :fix_broken

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
      attr_accessor :fix_missing

      #
      # Alias to fix_missing
      #
      attr_accessor :ignore_missing

      #
      # Disables downloading of packages.
      # This is best used with ignore_missing to force APT
      # to use only the .debs it has already downloaded.
      # Configuration Item: APT::Get::Download.
      #
      attr_accessor :no_download

      #
      # Quiet; produces output suitable for logging, omitting progress
      # indicators. You can also use 'quiet=#' to set the quiet level,
      # overriding the configuration file. Note that quiet level 2 implies 'yes',
      # you should never use 'quiet=2' without a no-action modifier
      # such as 'download_only', 'print_uris' or 'simulate' as APT may decided to
      # do something you did not expect.
      # Configuration Item: quiet.
      #
      attr_accessor :quiet

      #
      # No action; perform a simulation of events that would occur
      # but do not actually change the system.
      # Configuration Item: APT::Get::Simulate.
      # Simulate prints out a series of lines each one representing a
      # dpkg operation, Configure (Conf), Remove (Remv), Unpack (Inst).
      # Square brackets indicate broken packages with and empty set of square
      # brackets meaning breaks that are of no consequence (rare).
      #
      attr_accessor :simulate

      #
      # Alias to simulate
      #
      attr_accessor :just_print

      #
      # Alias to simulate
      #
      attr_accessor :dry_run

      #
      # Alias to simulate
      #
      attr_accessor :recon

      #
      # Alias to simulate
      #
      attr_accessor :no_act

      #
      # Automatic yes to prompts; assume "yes" as answer to all
      # prompts and run non-interactively. If an undesirable situation,
      # such as changing a held package or removing an essential package
      # occurs then apt-get will abort.
      # Configuration Item: APT::Get::Assume-Yes.
      #
      attr_accessor :assume_yes

      #
      # Alias to assume_yes
      #
      attr_accessor :yes

      #
      # Show upgraded packages; Print out a list of all packages
      # that are to be upgraded.
      # Configuration Item: APT::Get::Show-Upgraded.
      #
      attr_accessor :show_upgraded

      #
      # Show full versions for upgraded and installed packages.
      # Configuration Item: APT::Get::Show-Versions.
      #
      attr_accessor :verbose_version

      #
      # Compile source packages after downloading them.
      # Configuration Item: APT::Get::Compile.
      #
      attr_accessor :build

      #
      # Alias to build
      #
      attr_accessor :compile

      #
      # Also install recommended packages.
      #
      attr_accessor :install_recommends

      #
      # Do not install recommended packages.
      #
      attr_accessor :no_install_recommends

      #
      # Ignore package Holds; This causes apt-get to ignore a
      # hold placed on a package.
      # This may be useful in conjunction with dist-upgrade
      # to override a large number of undesired holds.
      # Configuration Item: APT::Ignore-Hold.
      #
      attr_accessor :ignore_hold

      #
      # Do not upgrade packages; When used in conjunction with
      # install no-upgrade will prevent packages listed from being
      # upgraded if they are already installed.
      # Configuration Item: APT::Get::Upgrade.
      #
      attr_accessor :no_upgrade

      #
      # Force yes; This is a dangerous option that will cause
      # apt to continue without prompting if it is doing something
      # potentially harmful. It should not be used except in very special
      # situations. Using 'force_yes' can potentially destroy your system!
      # Configuration Item: APT::Get::force-yes.
      #
      attr_accessor :force_yes

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
      attr_accessor :print_uris

      #
      # Use purge instead of remove for anything that would be removed.
      # An asterisk ("*") will be displayed next to packages which are
      # scheduled to be purged.
      # Configuration Item: APT::Get::Purge.
      #
      attr_accessor :purge

      #
      # Re-Install packages that are already installed and at the
      # newest version.
      # Configuration Item: APT::Get::ReInstall.
      #
      attr_accessor :reinstall

      #
      # This option defaults to on, use 'no_list_cleanup' to turn it off.
      # When on apt-get will automatically manage the contents of
      # /var/lib/apt/lists to ensure that obsolete files are erased.
      # The only reason to turn it off is if you frequently change your
      # source list.
      # Configuration Item: APT::Get::List-Cleanup.
      #
      attr_accessor :list_cleanup

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
      attr_accessor :default_release

      #
      # Alias to default_release
      #
      attr_accessor :target_release

      #
      # Only perform operations that are 'trivial'. Logically this can
      # be considered related to 'assume_yes', where 'assume_yes' will
      # answer yes to any prompt, 'trivial_only' will answer no.
      # Configuration Item: APT::Get::Trivial-Only.
      #
      attr_accessor :trivial_only

      #
      # If any packages are to be removed apt-get immediately aborts
      # without prompting.
      # Configuration Item: APT::Get::Remove
      #
      attr_accessor :no_remove

      #
      # If the command is either install or remove, then this option acts
      # like running autoremove command, removing the unused dependency
      # packages.
      # Configuration Item: APT::Get::AutomaticRemove.
      #
      attr_accessor :auto_remove

      #
      # Only has meaning for the source command.
      # Indicates that the given source names are not to be mapped
      # through the binary table. This means that if this option is specified,
      # the source command will only accept source package names as arguments,
      # rather than accepting binary package names and looking up the
      # corresponding source package.
      # Configuration Item: APT::Get::Only-Source
      #
      attr_accessor :only_source

      #
      # Download only the tar file of a source archive.
      # Configuration Item: APT::Get::Tar-Only
      #
      attr_accessor :tar_only

      #
      # Download only the dsc file of a source archive.
      # Configuration Item: APT::Get::Dsc-Only
      #
      attr_accessor :dsc_only

      #
      # Download only the diff file of a source archive.
      # Configuration Item: APT::Get::Diff-Only
      #
      attr_accessor :diff_only

      #
      # Ignore if packages can't be authenticated and don't prompt about
      # it. This is useful for tools like pbuilder.
      # Configuration Item: APT::Get::AllowUnauthenticated.
      #
      attr_accessor :allow_unauthenticated

      #
      # Only process architecture-dependent build-dependencies.
      # Configuration Item: APT::Get::Arch-Only
      #
      attr_accessor :arch_only

      #
      # Configuration File; Specify a configuration file to use.
      # The program will read the default configuration file and
      # then this configuration file.
      #
      attr_accessor :config_file

      #
      # Set a Configuration Option; This will set an arbitrary
      # configuration option.
      # The syntax is raptget.option = "Foo::Bar=bar"
      #
      attr_accessor :option

      #
      # Disable sudo. If this is not set, sudo
      # is used.
      #
      attr_accessor :disable_sudo

      #
      # Returns a new Raptget Object
      #
      def initialize()
      end

      #
      # install is followed by one or more packages desired for
      # installation or upgrading. Each package is a package name, not a
      # fully qualified filename (for instance, in a Debian GNU/Linux
      # system, libc6 would be the argument provided, not
      # libc6_1.9.6-2.deb). All packages required by the package(s)
      # specified for installation will also be retrieved and installed.
      # The /etc/apt/sources.list file is used to locate the desired
      # packages. If a hyphen is appended to the package name (with no
      # intervening space), the identified package will be removed if it is
      # installed. Similarly a plus sign can be used to designate a package
      # to install. These latter features may be used to override decisions
      # made by apt-get's conflict resolution system.
      #
      # A specific version of a package can be selected for installation by
      # following the package name with an equals and the version of the
      # package to select. This will cause that version to be located and
      # selected for install. Alternatively a specific distribution can be
      # selected by following the package name with a slash and the version
      # of the distribution or the Archive name (stable, testing,
      # unstable).
      #
      # Both of the version selection mechanisms can downgrade packages and
      # must be used with care.
      #
      # This is also the target to use if you want to upgrade one or more
      # already-installed packages without upgrading every package you have
      # on your system. Unlike the "upgrade" target, which installs the
      # newest version of all currently installed packages, "install" will
      # install the newest version of only the package(s) specified. Simply
      # provide the name of the package(s) you wish to upgrade, and if a
      # newer version is available, it (and its dependencies, as described
      # above) will be downloaded and installed.
      #
      # Finally, the apt_preferences mechanism allows you to create an
      # alternative installation policy for individual packages.
      #
      # If no package matches the given expression and the expression
      # contains one of '.', '?' or '*' then it is assumed to be a POSIX
      # regular expression, and it is applied to all package names in the
      # database. Any matches are then installed (or removed). Note that
      # matching is done by substring so 'lo.*' matches 'how-lo' and
      # 'lowest'. If this is undesired, anchor the regular expression with
      # a '^' or '$' character, or create a more specific regular
      # expression.
      #
      def install(packages)

        tmp = Tempfile.new('raptget_install')
        packages.collect! { |i| i + " " }
        command = option_string() + "install " + packages.to_s + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /Setting up/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # update is used to resynchronize the package index files from their
      # sources. The indexes of available packages are fetched from the
      # location(s) specified in /etc/apt/sources.list. For example, when
      # using a Debian archive, this command retrieves and scans the
      # Packages.gz files, so that information about new and updated
      # packages is available. An update should always be performed before
      # an upgrade or dist-upgrade. Please be aware that the overall
      # progress meter will be incorrect as the size of the package files
      # cannot be known in advance.
      def update

        tmp = Tempfile.new('raptget_update')
        command = option_string() + "update " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /Hit/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # upgrade is used to install the newest versions of all packages
      # currently installed on the system from the sources enumerated in
      # /etc/apt/sources.list. Packages currently installed with new
      # versions available are retrieved and upgraded; under no
      # circumstances are currently installed packages removed, or packages
      # not already installed retrieved and installed. New versions of
      # currently installed packages that cannot be upgraded without
      # changing the install status of another package will be left at
      # their current version. An update must be performed first so that
      # apt-get knows that new versions of packages are available.
      def upgrade

        tmp = Tempfile.new('raptget_upgrade')
        command = option_string() + "upgrade " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /^Setting up/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # dselect_upgrade is used in conjunction with the traditional Debian
      # packaging front-end, dselect.  'dselect_upgrade' follows the
      # changes made by dselect to the Status field of available
      # packages, and performs the actions necessary to realize that state
      # (for instance, the removal of old and the installation of new
      # packages).
      def dselect_upgrade

        tmp = Tempfile.new('raptget_dselect_upgrade')
        command = option_string() + "dselect-upgrade " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /^Setting up/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # dist_upgrade in addition to performing the function of upgrade,
      # also intelligently handles changing dependencies with new versions
      # of packages; apt-get has a "smart" conflict resolution system, and
      # it will attempt to upgrade the most important packages at the
      # expense of less important ones if necessary. So, 'dist_upgrade'
      # command may remove some packages. The /etc/apt/sources.list file
      # contains a list of locations from which to retrieve desired package
      # files. See also apt_preferences for a mechanism for overriding
      # the general settings for individual packages.
      def dist_upgrade

        tmp = Tempfile.new('raptget_dist_upgrade')
        command = option_string() + "dist-upgrade " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /^Setting up/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # remove is identical to install except that packages are removed
      # instead of installed. Note the removing a package leaves its
      # configuration files in system. If a plus sign is appended to the
      # package name (with no intervening space), the identified package
      # will be installed instead of removed.
      def remove(packages)

        tmp = Tempfile.new('raptget_remove')
        packages.collect! { |i| i + " " }
        command = option_string() + "remove " + packages.to_s + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /Removing/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # purge is identical to remove except that packages are removed and
      # purged (any configuration files are deleted too).
      def purge(packages)

        tmp = Tempfile.new('raptget_purge')
        packages.collect! { |i| i + " " }
        command = option_string() + "purge " + packages.to_s + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /Removing/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # source causes apt-get to fetch source packages. APT will examine
      # the available packages to decide which source package to fetch. It
      # will then find and download into the current directory the newest
      # available version of that source package while respect the default
      # release, set with the option APT::Default-Release, the 'target_release'
      # option or per package with the pkg/release syntax, if possible.
      #
      # Source packages are tracked separately from binary packages via
      # deb-src type lines in the sources.list file. This means that you
      # will need to add such a line for each repository you want to get
      # sources from. If you don't do this you will properly get another
      # (newer, older or none) source version than the one you have
      # installed or could install.
      #
      # If the 'compile' option is specified then the package will be
      # compiled to a binary .deb using dpkg-buildpackage, if
      # 'download_only' is specified then the source package will not be
      # unpacked.
      #
      # A specific source version can be retrieved by postfixing the source
      # name with an equals and then the version to fetch, similar to the
      # mechanism used for the package files. This enables exact matching
      # of the source package name and version, implicitly enabling the
      # APT::Get::Only-Source option.
      #
      # Note that source packages are not tracked like binary packages,
      # they exist only in the current directory and are similar to
      # downloading source tar balls.
      def source(packages)

        tmp = Tempfile.new('raptget_source')
        packages.collect! { |i| i + " " }
        command = option_string() + "source " + packages.to_s + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # 'build_dep' causes apt-get to install/remove packages in an attempt
      # to satisfy the build dependencies for a source package.
      def build_dep(packages)

        tmp = Tempfile.new('raptget_build_dep')
        packages.collect! { |i| i + " " }
        command = option_string() + "build-dep " + packages.to_s + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # clean clears out the local repository of retrieved package files.
      # It removes everything but the lock file from
      # /var/cache/apt/archives/ and /var/cache/apt/archives/partial/. When
      # APT is used as a dselect method, clean is run automatically.
      # Those who do not use dselect will likely want to run apt-get clean
      # from time to time to free up disk space.
      def clean

        command = option_string() + "clean "
        success = system(command)
        return success

      end

      # check is a diagnostic tool; it updates the package cache and checks
      # for broken dependencies.
      def check

        tmp = Tempfile.new('raptget_check')
        command = option_string() + "check " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # Like clean, autoclean clears out the local repository of retrieved
      # package files. The difference is that it only removes package files
      # that can no longer be downloaded, and are largely useless. This
      # allows a cache to be maintained over a long period without it
      # growing out of control. The configuration option
      # APT::Clean-Installed will prevent installed packages from being
      # erased if it is set to off.
      def autoclean

        tmp = Tempfile.new('raptget_autoclean')
        command = option_string() + "autoclean " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      # autoremove is used to remove packages that were automatically
      # installed to satisfy dependencies for some package and that are no
      # more needed.
      def autoremove

        tmp = Tempfile.new('raptget_autoremove')
        command = option_string() + "autoremove " + " 2> " + tmp.path
        success = system(command)
        if success
          begin
            while (line = tmp.readline)
              line.chomp
              selected_string = line if line =~ /Removing/
            end
          rescue EOFError
            tmp.close
          end
          return selected_string
        else
          tmp.close!
          return success
        end

      end

      private

      def option_string()
        unless @disable_sudo
          ostring = "sudo apt-get "
        else
          ostring = "apt-get "
        end

        if @option
          ostring += "--option " + @option
        end

        if @config_file
          ostring += "--config-file " + @config_file
        end

        if @arch_only
          ostring += "--arch-only "
        end

        if @allow_unauthenticated
          ostring += "--allow-unauthenticated "
        end

        if @diff_only
          ostring += "--diff-only "
        end

        if @dsc_only
          ostring += "--dsc-only "
        end

        if @tar_only
          ostring += "--tar-only "
        end

        if @only_source
          ostring += "--only-source "
        end

        if @auto_remove
          ostring += "--auto-remove "
        end

        if @no_remove
          ostring += "--no-remove "
        end

        if @trivial_only
          ostring += "--trivial-only "
        end

        if @target_release
          ostring += "--target-release " + @target_release
        end

        if @default_release
          ostring += "--default-release " + @default_release
        end

        if @list_cleanup
          ostring += "--list-cleanup "
        end

        if @reinstall
          ostring += "--reinstall "
        end

        if @purge
          ostring += "--purge "
        end

        if @print_uris
          ostring += "--print-uris "
        end

        if @force_yes
          ostring += "--force-yes "
        end

        if @only_upgrade
          ostring += "--only-upgrade "
        end

        if @no_upgrade
          ostring += "--no-upgrade "
        end

        if @ignore_hold
          ostring += "--ignore-hold "
        end

        if @no_install_recommends
          ostring += "--no-install-recommends "
        end

        if @install_recommends
          ostring += "--install-recommends "
        end

        if @compile
          ostring += "--compile "
        end

        if @build
          ostring += "--build "
        end

        if @verbose_versions
          ostring += "--verbose-versions "
        end

        if @show_upgraded
          ostring += "--show-upgraded "
        end

        if @yes
          ostring += "--yes "
        end

        if @assume_yes
          ostring += "--assume-yes "
        end

        if @simulate
          ostring += "--simulate "
        end

        if @just_print
          ostring += "--just-print "
        end

        if @dry_run
          ostring += "--dry-run "
        end

        if @recon
          ostring += "--recon "
        end

        if @no_act
          ostring += "--no-act "
        end

        if @quiet
          ostring += "--quiet " + @quiet
        end

        if @no_download
          ostring += "--no-download "
        end

        if @ignore_missing
          ostring += "--ignore-missing "
        end

        if @fix_missing
          ostring += "--fix-missing "
        end

        if @fix_broken
          ostring += "--fix-broken "
        end

        if @download_only
          ostring += "--download-only "
        end

        return ostring

      end
    end
  end
