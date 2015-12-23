#!/usr/bin/env ruby
# @encoding: utf-8
# @author: Sascha Manns
# @abstract: hoe-manns is a small collection of my personal used rake tasks for using with hoe
#
# Copyright (c) 2015 Sascha Manns <samannsml@directbox.com>
# License: MIT

# Dependencies

# Main module for hoe-manns
module Hoe::Manns
  # Version constant for HOE::Manns
  VERSION = '1.4.5'

  attr_accessor :remove_pre_gemspec
  attr_accessor :update_index
  attr_accessor :copy_manuals
  attr_accessor :copy_master
  attr_accessor :copy_mirror
  attr_accessor :copy_wiki
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
    require 'pandoc-ruby'
  end

  # Definitions of the Rake task
  def define_manns_tasks
    # rubocop:disable Metrics/LineLength
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
    task :copy_mirror => %w(clean_pkg) do
      Hoe::Manns.copy_mirror_method
    end

    # Rake Task for git tag
    desc 'Copy master'
    task :copy_master do
      Hoe::Manns.copy_master
    end

    # Rake Task for running needed Rake Tasks before running rake release
    desc 'Run all tasks before rake release'
    task :run_before_release => %w(git:manifest bundler:gemfile bundler:gemfile_lock update_index gem:spec_remove
update_workspace bundle_audit:run copy_mirror copy_master) do
      puts 'Ready to run rake release VERSION=x.y.z'.colour(:green)
    end

    # Rake Task for running needed Rake Tasks after running rake release
    desc 'Run all tasks after rake release'
    task :run_after_release => %w(send_email clean_pkg create_packages deploy_packages) do
      puts 'Release finished'.colour (:green)
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
    %w(Rakefile Gemfile Gemfile.lock .autotest .codeclimate.yml .coveralls.yml .gemnasium.yml .gitignore .index .rspec .rubocop.yml
.scrutinizer.yml .travis.yml CODE_OF_CONDUCT.md config.reek CONTRIBUTING.md History.rdoc Index.yml LICENSE.rdoc MAINTENANCE.md Manifest.txt
README.rdoc VERSION recipes/recipe.rb).each do |i|
      system("git add #{i}") if File.exist?(i)
    end
    %w(bin etc data docs lib test).each do |d|
      system("git add #{d}/*") if File.exist?(d)
    end
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
    config = YAML.load(File.read("#{Dir.home}/.hoerc"))
    docpath = config['manns']['docpath'].to_s
    FileUtils.cp_r('manual/output', "#{docpath}/#{project}")
    puts 'Copied manuals'.colour(:green)
  end

  # Method for copying to mirror
  def self.copy_mirror_method
    project = Hoe::Manns.get_projectname
    develpath = Hoe::Manns.get_develpath
    source = "#{develpath}/#{project}"
    destination = "#{develpath}/#{project}-mirror"
    puts 'Copying to mirror'.colour(:yellow)
    Hoe::Manns.copy_mirror_create_dirs(source, destination)
    FileUtils.cp_r "#{source}/recipes/recipe.rb", "#{destination}/recipes/recipe.rb", verbose: true if File.exist?("#{source}/recipes/recipe.rb")
    Hoe::Manns.copy_mirror_copy_files(source, destination)
    system('git status')
    puts 'Copying to mirror succeeded'.colour(:green)
  end

  def self.copy_mirror_create_dirs(source, destination)
    %w(bin etc data docs lib test recipes).each do |d|
      unless File.exist?("#{destination}/#{d}") # if d isn't available in destination
        FileUtils.mkdir("#{destination}/#{d}") if File.exist?("#{source}/#{d}") # and exist in source then create them
      end
      FileUtils.cp_r "#{source}/#{d}/.", "#{destination}/#{d}/.", verbose: true if File.exist?("#{source}/#{d}") # copy the content of the dirs
    end
  end

  def self.copy_mirror_copy_files(source, destination)
    FileUtils.cd(destination) do
      %w(Rakefile Gemfile Gemfile.lock .autotest .codeclimate.yml .coveralls.yml .gemnasium.yml .gitignore .index .rspec .rubocop.yml
.scrutinizer.yml .travis.yml CODE_OF_CONDUCT.md config.reek CONTRIBUTING.md History.rdoc Index.yml LICENSE.rdoc MAINTENANCE.md Manifest.txt
README.rdoc VERSION).each do |i|
        FileUtils.cp_r "#{source}/#{i}", "#{destination}", verbose: true if File.exist?("#{source}/#{i}")
        system("git add #{i}") if File.exist?(i)
        %w(bin etc docs lib test).each do |d|
          system("git add #{d}/*") if File.exist?(d)
        end
      end
      system('git commit -m "Sync mirror" && git push')
    end
  end

  # Copies the actual wiki entries to ./docs
  def self.copy_wiki_method
    puts 'Copying wiki content to docs'.colour(:yellow)
    project = Hoe::Manns.get_projectname
    develpath = Hoe::Manns.get_develpath
    wikipath = "#{develpath}/#{project}.wiki"
    FileUtils.mkdir_p 'docs', verbose: true unless File.exist?('docs')
    FileUtils.cd(wikipath) do
      system('git pull')
    end
    files = Dir.glob("#{wikipath}/*.md")
    FileUtils.cp files, 'docs', verbose: true
    FileUtils.mv 'docs/home.md', 'docs/index.md', verbose: true
    FileUtils.cd('docs') do
      Dir['*.md'].each do |f|
        PandocRuby.allow_file_paths = true
        @converter = PandocRuby.new(f, :from => :markdown, :to => :rst)
        File.open(f, 'w') do |file1|
          file1.puts @converter.convert
        end
        extn = File.extname  f        # => ".mp4"
        name = File.basename f, extn  # => "xyz"
        FileUtils.mv "#{name}.md", "#{name}.rst"
      end
    end
    puts 'Copied wiki content'.colour(:green)
  end

  # Method for copying to master
  def self.copy_master
    puts 'Checking out master'.colour(:yellow)
    system('git checkout master')
    puts 'Merging master with develop'.colour(:yellow)
    system('git merge develop')
    puts 'Pushing master to origin'.colour(:yellow)
    system('git add recipes/recipe.rb') if File.exist?('recipes/recipe.rb')
    system('git push')
    puts 'Creating git tag'.colour(:yellow)
    version = Hoe::Manns.get_version
    system("git tag -a v#{version} -m 'version #{version}'")
    system('git push origin  --tags')
    puts 'Checking out develop again'.colour(:yellow)
    system('git checkout develop')
    puts 'Done'.colour(:green)
  end

  # Method for getting the project name
  def self.get_projectname
    pnameraw = File.open(*Dir.glob('README.*')) { |f| f.readline }
    project = pnameraw.gsub(/[^0-9A-Za-z_-]/, '')
    return project
  end

  # Method for getting the develpath
  def self.get_develpath
    config = YAML.load(File.read("#{Dir.home}/.hoerc"))
    develpath = config['manns']['develpath'].to_s
    return develpath
  end

  # Method for getting version
  # @return [String] version
  def self.get_version
    version = File.open(*Dir.glob('VERSION')) { |f| f.readline }
    version.chomp.to_s
  end

  # Method for cleanup the pkg
  def self.clean_pkg_method
    puts 'Cleaning pkg'.colour(:yellow)
    FileUtils.rm_rf('pkg') if Dir.exist?('pkg')
    FileUtils.rm_rf('recipes/pkg') if Dir.exist?('recipes/pkg')
    puts 'Cleanup succeed'.colour(:green)
  end

end
