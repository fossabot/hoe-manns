#!/usr/bin/env ruby
# @encoding: utf-8
# @author: Sascha Manns
# @abstract: hoe-manns is a small collection of my personal used rake tasks for using with hoe
#
# Copyright (c) 2015 Sascha Manns <samannsml@directbox.com>
# License: MIT

# Dependencies

# empty main class
class Hoe; end

# Main module for hoe-manns
module Hoe::Manns
  # Version constant for HOE::Manns
  VERSION = '1.0.2'

  attr_accessor :update_gemfile_lock
  attr_accessor :remove_pre_gemspec
  attr_accessor :update_workspace
  attr_accessor :update_index
  attr_accessor :copy_manuals
  attr_accessor :copy_mirror
  attr_accessor :run_before_release
  attr_accessor :run_after_release
  attr_accessor :clean_pkg
  attr_accessor :bundler_audit

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
    task :update_gemfile_lock do
      Hoe::Manns.update_gemfile_lock_method
    end

    # Rake Task for removing Prerelease Gemspecs
    desc 'Remove Pre-Gemspec'
    task :remove_pre_gemspec do
      Hoe::Manns.remove_pre_gemspec_method
    end

    # Rake Task for updating the workspace
    desc 'Update Workspace'
    task :update_workspace do
      Hoe::Manns.update_workspace_method
    end

    # Rake Task for updating the .index
    desc 'Update .index'
    task :update_index do
      Hoe::Manns.update_index_method
    end

    # Rake Task for copying manuals
    require 'parseconfig'
    desc 'Copy manuals'
    task :copy_manuals do
      Hoe::Manns.copy_manuals_method
    end

    # Rake task for copying to mirror
    desc 'Coying to mirror'
    task :copy_mirror do
      Hoe::Manns.copy_mirror_method
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

    # Rake Task for running needed Rake Tasks before running rake release
    desc 'Run all tasks before rake release'
    task :run_before_release => %w(git:manifest bundler:gemfile update_gemfile_lock update_index remove_pre_gemspec
update_workspace bundle_audit:run copy_mirror) do
      puts 'Ready to run rake release VERSION=x.y.z'.colour(:green)
    end

    # Rake Task for running needed Rake Tasks after running rake release
    desc 'Run all tasks after rake release'
    task :run_after_release => %w(send_email version:bump) do
      puts 'Release finished'.colour (:green)
    end

    # Rake Task for cleaning up the pkg
    desc 'Clean pkg'
    task :clean_pkg do
      Hoe::Manns.clean_pkg_method
    end
  end

  require 'rainbow/ext/string'
  # Method for updating Gemfile.lock
  def self.update_gemfile_lock_method
    puts 'Updating Gemfile.lock'.colour(:yellow)
    system('bundle update')
    puts 'Updated Gemfile.lock'.colour(:green)
  end

  # Method for removing prerelease gemspec
  def self.remove_pre_gemspec_method
    puts 'Removing pre version of gemspec'.colour(:yellow)
    File.delete(*Dir.glob('*.gemspec'))
    puts 'Removed'.colour(:green)
  end

  # Method for updating workspace
  def self.update_workspace_method
    puts 'Updating workspace'.colour(:yellow)
    system('git add Manifest.txt Gemfile Gemfile.lock')
    system('git commit -m "Updated workspace"')
    system('git push')
    system('git status')
    puts 'Updated workspace'.colour(:green)
  end

  # Method for updating .index
  def self.update_index_method
    puts 'Updating .index. Have you changed your VERSION file?'.colour(:yellow)
    system('index --using VERSION Index.yml')
    system('git add .index')
    puts '.index updated'.colour(:green)
  end

  # Method for copying the manuals to a target directory
  def self.copy_manuals_method
    puts 'Copying manual pages to target'.colour(:yellow)
    project = Hoe::Manns.get_projectname
    config = ParseConfig.new(File.join("#{Dir.home}/.hoe-manns/hoe-manns.cfg"))
    docpath = config['docpath'].to_s
    FileUtils.cp_r('manual/output', "#{docpath}/#{project}")
  end

  # Method for copying to mirror
  def self.copy_mirror_method
    project = Hoe::Manns.get_projectname
    source = "#{Dir.home}/RubymineProjects/#{project}"
    destination = "#{Dir.home}/RubymineProjects/#{project}-github"
    puts 'Copying to mirror'.colour(:yellow)
    FileUtils.cp_r "#{source}/lib/.", "#{destination}/lib/.", verbose: true
    FileUtils.cp_r "#{source}/test/.", "#{destination}/test/.", verbose: true
    FileUtils.cp_r "#{source}/Rakefile", "#{destination}", verbose: true
    FileUtils.cp_r "#{source}/Gemfile", "#{destination}", verbose: true
    FileUtils.cp_r "#{source}/Gemfile.lock", "#{destination}", verbose: true
    puts 'Copying to mirror succeeded'.colour(:green)
  end

  # Method for getting the project name
  def self.get_projectname
    pnameraw = File.open(*Dir.glob('README.*')) {|f| f.readline}
    project = pnameraw.gsub(/[^0-9A-Za-z_]/, '')
    return project
  end

  # Method for cleanup the pkg
  def self.clean_pkg_method
    puts 'Cleaning pkg'.colour(:yellow)
    FileUtils.rm_rf('pkg') if Dir.exist?('pkg')
    puts 'Cleanup succeed'.colour(:green)
  end
end
