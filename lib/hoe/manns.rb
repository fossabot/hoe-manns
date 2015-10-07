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
  VERSION = '1.2.0'

  attr_accessor :remove_pre_gemspec
  attr_accessor :update_index
  attr_accessor :copy_manuals
  attr_accessor :copy_mirror
  attr_accessor :copy_wiki
  attr_accessor :create_packages
  attr_accessor :deploy_packages
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
    require 'rest-client'
    require 'fpm'
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

    # Rake Task for copying the GitLab Wiki to ./doc
    desc 'Copy Wiki'
    task :copy_wiki do
      Hoe::Manns.copy_wiki_method
    end

    # Rake task for copying to mirror
    desc 'Coying to mirror'
    task :copy_mirror do
      Hoe::Manns.copy_mirror_method
    end

    # Rake Task for building packages
    desc 'Creating deb and rpm files'
    task :create_packages => %w(clean_pkg package) do
      Hoe::Manns.create_packages_method
    end

    # Rake task for deploying packages
    desc 'Deploying packages to bintray'
    task :deploy_packages do
      Hoe::Manns.deploy_bintray_method
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
    task :run_before_release => %w(git:manifest bundler:gemfile bundler:gemfile_lock update_index gem:spec_remove
update_workspace bundle_audit:run copy_mirror) do
      puts 'Ready to run rake release VERSION=x.y.z'.colour(:green)
    end

    # Rake Task for running needed Rake Tasks after running rake release
    desc 'Run all tasks after rake release'
    task :run_after_release => %w(send_email generate_packages deploy_packages) do
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
    system('git add Manifest.txt Gemfile Gemfile.lock Rakefile History.* README.*')
    system('git add bin/*') if File.exist?('bin')
    system('git add data/*') if File.exist?('data')
    system('git add etc/*') if File.exist?('etc')
    system('git add lib/*') if File.exist?('lib')
    system('git add test/*') if File.exist?('test')
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
    puts 'Copied manuals'.colour(:green)
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
    FileUtils.cd(destination) do
      system('git add * && git commit -m "Sync mirror" && git push')
    end
    puts 'Copying to mirror succeeded'.colour(:green)
  end

  # Copies the actual wiki entries to ./doc
  def self.copy_wiki_method
    puts 'Copying wiki content to docs'.colour(:yellow)
    project = Hoe::Manns.get_projectname
    develpath = Hoe::Manns.get_develpath
    dest = "#{develpath}#{project}"
    wikipath = "#{develpath}#{project}.wiki"
    FileUtils.mkdir_p "#{dest}/doc", verbose: true if File.exist?('docs') == false
    files = Dir.glob("#{wikipath}/*.md")
    FileUtils.cp files, "#{dest}/docs", verbose: true
    FileUtils.mv "#{dest}/docs/home.md", "#{dest}/docs/index.md", verbose: true
    puts 'Copied wiki content'.colour(:green)
  end

  # Method for creating deb and rpm packages
  def self.create_packages_method
    project = Hoe::Manns.get_projectname
    FileUtils.cd("recipes/#{project}") do
      puts 'Creating the deb package'.colour(:yellow)
      system('fpm-cook -t deb')
      puts 'deb creating done'.colour(:green)
      puts 'Creating the rpm package'.colour(:yellow)
      system('fpm-cook -t rpm')
      puts 'rpm creating done'.colour(:green)
    end
  end

  # Method for deploying to bintray
  def self.deploy_bintray_method
    project = Hoe::Manns.get_projectname
    config = ParseConfig.new(File.join("#{Dir.home}/.hoe-manns/hoe-manns.cfg"))
    user = config['bintray_user'].to_s
    apikey = config['bintray_api_key'].to_s
    file_target_path = 'pool/main/r'
    version = File.open(*Dir.glob('VERSION')) { |f| f.readline }
    puts 'Deploying packages to bintray'.colour(:yellow)
    FileUtils.cd("recipes/#{project}/pkg") do
      filerpm = Dir.glob('*.rpm')
      filedeb = Dir.glob('*.deb')
      rpm = filerpm.first.to_s
      deb = filedeb.first.to_s
      system("curl -T #{rpm} -u#{user}:#{apikey} https://api.bintray.com/content/#{user}/rpm/#{project}/v#{version}/#{file_target_path}/")
      system("curl -T #{deb} -u#{user}:#{apikey} 'https://api.bintray.com/content/#{user}/deb/#{project}/v#{version}/#{file_target_path}/#{deb};deb_distribution=ubuntu;deb_component=main;deb_architecture=i386,amd64'")
    end
    puts 'Deploying succeeded'.colour(:green)
  end

  # Method for getting the project name
  def self.get_projectname
    pnameraw = File.open(*Dir.glob('README.*')) { |f| f.readline }
    project = pnameraw.gsub(/[^0-9A-Za-z_-]/, '')
    return project
  end

  # Method for getting the develpath
  def self.get_develpath
    config = ParseConfig.new(File.join("#{Dir.home}/.hoe-manns/hoe-manns.cfg"))
    develpath = config['develpath'].to_s
    return develpath
  end

  # Method for cleanup the pkg
  def self.clean_pkg_method
    puts 'Cleaning pkg'.colour(:yellow)
    FileUtils.rm_rf('pkg') if Dir.exist?('pkg')
    puts 'Cleanup succeed'.colour(:green)
  end
end
