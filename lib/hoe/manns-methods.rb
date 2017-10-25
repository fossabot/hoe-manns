# Copyright (C) 2013-2017 Sascha Manns <Sascha.Manns@mailbox.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Dependencies
require 'rainbow/ext/string'

# Module Hoe
# rubocop:disable Metrics/ClassAndModuleChildren
module Hoe::MannsMethods
  # Installs a bundle
  def self.bundle_install
    puts 'Installing Bundle'.color(:yellow)
    system('bundle install')
    puts 'Installed Bundle'.color(:green)
  end

  # Update Gemfile.lock
  def self.update_gemfile_lock_method
    puts 'Updating Gemfile.lock'.color(:yellow)
    system('bundle update')
    puts 'Updated Gemfile.lock'.color(:green)
  end

  # Remove prerelease gemspec
  def self.remove_pre_gemspec_method
    puts 'Removing pre version of gemspec'.color(:yellow)
    File.delete(*Dir.glob('*.gemspec'))
    puts 'Removed'.color(:green)
  end

  # Copying stuff to master
  def self.copy_master
    copy_master_co_master
    puts 'Set a Git Tag'.color(:yellow)
    system('rake git:tag')
    puts 'Checking out develop again'.color(:yellow)
    system('git checkout develop')
    puts 'Done'.color(:green)
  end

  # Check out master
  def self.copy_master_co_master
    puts 'Checking out master'.color(:yellow)
    system('git checkout master')
    puts 'Merging master with develop'.color(:yellow)
    system('git merge develop')
    puts 'Pushing master to origin'.color(:yellow)
    system('git push')
  end

  # Cleanup the pkg
  def self.clean_pkg_method
    puts 'Cleaning pkg'.color(:yellow)
    FileUtils.rm_rf('pkg') if Dir.exist?('pkg')
    FileUtils.rm_rf('recipes/pkg') if Dir.exist?('recipes/pkg')
    puts 'Cleanup succeed'.color(:green)
  end
end
