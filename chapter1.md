# Deeper Insight

---

## About

This kind of documentation explains a little bit more. 

Before you start, edit your ~/.hoerc and add (example):

```
manns: 
    docpath: /home/sascha/RubymineProjects/saigkill.github.com/docs 
    develpath: /home/sascha/RubymineProjects
```

The docpath is optional if you like to use the update_manuals task. It expects to have a directory "manual/output" (created from the hoe-manualgen plugin).The develpath is the path to your development projects. It will used by the copy_wiki task.

---

### The methods

```ruby
require 'rainbow/ext/string' 
def self.update_gemfile_lock_method 
puts 'Updating Gemfile.lock'.color(:yellow) 
system('bundle update') 
puts 'Updated Gemfile.lock'.color(:green) 
end
```

That one does only a "bundle update" to update the Gemfile.lock.

```ruby
def self.remove_pre_gemspec_method 
puts 'Removing pre version of gemspec'.color(:yellow) File.delete(*Dir.glob('*.gemspec')) 
puts 'Removed'.color(:green) 
end
```

If you have produced a prerelease gemspec you maybe like this method. It removes the gemspec from your sources.

```ruby
puts 'Updating workspace'.colour(:yellow) 
%w(Rakefile Gemfile Gemfile.lock .autotest .codeclimate.yml .coveralls.yml .gemnasium.yml .gitignore .index .rspec .rubocop.yml.scrutinizer.yml .travis.yml CODE_OF_CONDUCT.md config.reek CONTRIBUTING.md History.rdoc Index.yml LICENSE.rdoc MAINTENANCE.md Manifest.txt README.rdoc VERSION recipes/recipe.rb).each do |i| system("git add #{i}") if File.exist?(i) 
end 
%w(bin etc data docs lib test).each do |d| 
system("git add #{d}/*") if File.exist?(d) 
end 
system('git commit -m "Updated workspace"') 
system('git push') 
system('git status') 
puts 'Updated workspace'.colour(:green)
```

This method adds the whole workspace to git and commits them to the current branch.

```ruby
def self.copy_manuals_method 
puts 'Copying manual pages to target'.color(:yellow) 
pnameraw = File.open(*Dir.glob('README.*')) {|f| f.readline} 
project = pnameraw.gsub(/[^0-9A-Za-z]/, '') 
config = ParseConfig.new(File.join("#{Dir.home}/.hoe-manns/hoe-manns.cfg")) 
docpath = config['docpath'].to_s 
FileUtils.cp_r('manual/output', "#{docpath}/#{project}") 
end
```

My project documentation is part of my Jekyll blog. The docdir resides now in "~/RubyMine/saigkill.github.io/docs".

```ruby
def self.clean_pkg_method 
puts 'Cleaning pkg'.color(:yellow) 
FileUtils.rm_rf('pkg') if Dir.exist?('pkg') 
FileUtils.rm_rf('recipes/pkg') if Dir.exist?('recipes/pkg') 
puts 'Cleanup succeed'.color(:green) 
end
```

Sometimes it can be useful to remove the pkg and recipes/pkg directory from your source. So just launch this method to do this.

```ruby
namespace :bundle_audit do 
desc 'Update bundle-audit database' 
task :update do Bundler::Audit::CLI.new.update 
end 
desc 'Check gems for vulns using bundle-audit' 
task :check do Bundler::Audit::CLI.new.check 
end 
desc 'Update vulns database and check gems using bundle-audit' 
task :run do Rake::Task['bundle_audit:update'].invoke Rake::Task['bundle_audit:check'].invoke 
end 
end 
task :bundle_audit do 
Rake::Task['bundle_audit:run'].invoke 
end```

This Rake task provides 3 new Rake commands: bundle_audit:update, bundle_audit:run, and bundle_audit:check. A bundle_audit:run does bundle_audit:update and bundle_update:check. So you need in most cases just that one command.

```ruby
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
system('git push origin --tags') 
puts 'Checking out develop again'.colour(:yellow) 
system('git checkout develop') 
puts 'Done'.colour(:green) 
end
```

That method checks out the master, merges it with the develop branch and pushs it to origin/master. Then it creates a git tag with the version number and pushs all known tags to origin.

---

### The Rake tasks

In most cases you don't run the method directly, but use a Rake Task. All Rake tasks in hoe-manns having a common structure:

```ruby
desc 'Update Gemfile.lock'task :update_gemfile_lock do Hoe::Manns.update_gemfile_lock_method
end
```

You see, it just runs the method. A task ":update_gemfile_lock" runs a "update_gemfile_lock_method". hoe-manns ships two Rake tasks without any methods. These tasks are used to run a bunch of other tasks in a special order.

```ruby
desc 'Run all tasks before rake release' 
task :run_before_release => %w(git:manifest bundler:gemfile bundler:gemfile_lock gem:spec_remove update_workspace bundle_audit:run copy_master) do 
puts 'Ready to run rake release VERSION=x.y.z'.colour(:green) 
end
```

This rake task runs some rake tasks in that order: git:manifest, bundler:gemfile, bundler:gemfile_lock, gem:spec_remove, update_workspace, bundle_audit:run and copy_master.

```ruby
desc 'Run all tasks after rake release' 
task :run_after_release => %w(send_email clean_pkg) do 
puts 'Release finished'.colour (:green) 
end
```

This task runs: send_email , clean_pkg. That can be useful to automate things after the release.
