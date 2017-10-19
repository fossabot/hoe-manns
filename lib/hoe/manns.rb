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
require 'hoe'

# Main module for hoe-manns
module Hoe::Manns
  # Version constant for HOE::Manns
  VERSION = '1.6.2'.freeze

  attr_accessor :remove_pre_gemspec
  attr_accessor :copy_manuals
  attr_accessor :copy_master
  attr_accessor :run_before_release
  attr_accessor :run_after_release
  attr_accessor :clean_pkg
  attr_accessor :bundle_audit

  # Initialize plugin
  def initialize_manns
    require 'yaml'
    require 'fileutils'
    require 'parseconfig'
    require 'rainbow/ext/string'
    require 'bundler/audit/cli'
  end

  # Definitions of the Rake task
  def define_manns_tasks
    # Rake Task for updating Gemfile.lock
    desc 'Update Gemfile.lock'
    task 'bundler:gemfile_lock' do
      Hoe::Manns.update_gemfile_lock_method
    end

    # Rake Task for removing Prerelease Gemspecs
    desc 'Remove Pre-Gemspec'
    task 'gem:spec_remove' do
      Hoe::Manns.remove_pre_gemspec_method
    end

    # Rake Task for updating the workspace
    desc 'Update Workspace'
    task :update_workspace do
      Hoe::Manns.update_workspace_method
    end

    # Rake Task for copying manuals
    require 'parseconfig'
    desc 'Copy manuals'
    task :copy_manuals do
      Hoe::Manns.copy_manuals_method
    end

    # Rake Task for git tag
    desc 'Copy master'
    task :copy_master do
      Hoe::Manns.copy_master
    end

    # Rake Task for running needed Rake Tasks before running rake release
    desc 'Run all tasks before rake release'
    task run_before_release: %w[git:manifest bundler:gemfile
                                bundler:gemfile_lock gem:spec_remove bundle_audit:run update_workspace
                                copy_master] do
      puts 'Ready to run rake release VERSION=x.y.z'.colour(:green)
    end

    # Rake Task for running needed Rake Tasks after running rake release
    desc 'Run all tasks after rake release'
    task run_after_release: %w[send_email clean_pkg] do
      puts 'Release finished'.colour :green
    end

    # Rake Task for cleaning up the pkg
    desc 'Clean pkg'
    task :clean_pkg do
      Hoe::Manns.clean_pkg_method
    end

    # Method for bundle audit
    namespace :bundle_audit do
      desc 'Update bundle-audit database'
      task :update do
        Bundler::Audit::CLI.new.update
      end

      desc 'Check gems for vulns using bundle-audit'
      task :check do
        Bundler::Audit::CLI.new.check
      end

      desc 'Update vulns database and check gems using bundle-audit'
      task :run do
        Rake::Task['bundle_audit:update'].invoke
        Rake::Task['bundle_audit:check'].invoke
      end
    end
    task :bundle_audit do
      Rake::Task['bundle_audit:run'].invoke
    end
  end

  require 'rainbow/ext/string'
  # Method for updating Gemfile.lock
  def self.update_gemfile_lock_method
    puts 'Updating Gemfile.lock'.color(:yellow)
    system('bundle update')
    puts 'Updated Gemfile.lock'.color(:green)
  end

  # Method for removing prerelease gemspec
  def self.remove_pre_gemspec_method
    puts 'Removing pre version of gemspec'.color(:yellow)
    File.delete(*Dir.glob('*.gemspec'))
    puts 'Removed'.color(:green)
  end

  # Method for updating workspace
  def self.update_workspace_method
    puts 'Updating workspace'.color(:yellow)
    %w[Rakefile Gemfile Gemfile.lock .autotest .codeclimate.yml .coveralls.yml
       .gemnasium.yml .gitignore .rspec .rubocop.yml .scrutinizer.yml .travis.yml
       CODE_OF_CONDUCT.md config.reek CONTRIBUTING.md History.rdoc Index.yml
       LICENSE.rdoc MAINTENANCE.md Manifest.txt README.rdoc VERSION
       recipes/recipe.rb].each do |i|
      system("git add #{i}") if File.exist?(i)
    end
    %w[bin etc data docs lib test spec].each do |d|
      system("git add #{d}/*") if File.exist?(d)
    end
    system('git commit -m "Updated workspace"')
    system('git push')
    system('git status')
    puts 'Updated workspace'.color(:green)
  end

  # Method for copying to master
  def self.copy_master
    puts 'Checking out master'.color(:yellow)
    system('git checkout master')
    puts 'Merging master with develop'.color(:yellow)
    system('git merge develop')
    puts 'Pushing master to origin'.color(:yellow)
    system('git add recipes/recipe.rb') if File.exist?('recipes/recipe.rb')
    system('git push')
    puts 'Set a Git Tag'.color(:yellow)
    system('rake git:tag')
    puts 'Checking out develop again'.color(:yellow)
    system('git checkout develop')
    puts 'Done'.color(:green)
  end

  # Method for cleanup the pkg
  def self.clean_pkg_method
    puts 'Cleaning pkg'.color(:yellow)
    FileUtils.rm_rf('pkg') if Dir.exist?('pkg')
    FileUtils.rm_rf('recipes/pkg') if Dir.exist?('recipes/pkg')
    puts 'Cleanup succeed'.color(:green)
  end
end
