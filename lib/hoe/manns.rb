# Copyright (C) 2013-2018 Sascha Manns <Sascha.Manns@outlook.de>
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
require_relative 'manns-methods.rb'

# Main module Hoe
# TODO: Currently i don't know how to fix this.
# Nested usage triggers error "hoe not a module"
# rubocop:disable Metrics/ClassAndModuleChildren
module Hoe::Manns
  # Version constant for HOE::Manns
  VERSION = '2.1.4'.freeze

  attr_accessor :remove_pre_gemspec
  attr_accessor :copy_master
  attr_accessor :run_before_release
  attr_accessor :clean_pkg
  attr_accessor :bundle_audit

  # Initialize plugin
  def initialize_manns
    require 'fileutils'
    require 'rainbow/ext/string'
    require 'bundler/audit/cli'
  end

  # Definitions of the Rake task
  # TODO: Check if this smells can be pacified in future
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # This method smells of :reek:TooManyStatements
  def define_manns_tasks
    # Install a Bundle
    desc 'Install a Bundle'
    task 'bundler:gemfile_install' do
      Hoe::MannsMethods.bundle_install
    end

    # Task for updating Gemfile.lock
    desc 'Update Gemfile.lock'
    task 'bundler:gemfile_lock' do
      Hoe::MannsMethods.update_gemfile_lock_method
    end

    # Task for removing Prerelease Gemspecs
    desc 'Remove Pre-Gemspec'
    task 'gem:spec_remove' do
      Hoe::MannsMethods.remove_pre_gemspec_method
    end

    # Task for git tag
    desc 'Copy master'
    task :copy_master do
      Hoe::MannsMethods.copy_master
    end

    # Task for running needed Rake Tasks before running rake release
    desc 'Run all tasks before rake release'
    task run_before_release:
             %w[git:manifest bundler:gemfile bundler:gemfile_lock gem:spec_remove bundle_audit:run copy_master] do
      puts 'Ready to run rake release VERSION=x.y.z'.color(:green)
    end

    # Task for cleaning up the pkg
    desc 'Clean pkg'
    task :clean_pkg do
      Hoe::MannsMethods.clean_pkg_method
    end

    # Tasks for bundle audit
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
end
