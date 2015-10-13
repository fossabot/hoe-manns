# About
This kind of documentation explains what makes the "red pill".

## The methods

```ruby
require 'rainbow/ext/string'
  # Method for updating Gemfile.lock
  def self.update_gemfile_lock_method
    puts 'Updating Gemfile.lock'.color(:yellow)
    system('bundle update')
    puts 'Updated Gemfile.lock'.color(:green)
  end
```
That one does only a "bundle update" to update the Gemfile.lock.

```ruby
# Method for removing prerelease gemspec
  def self.remove_pre_gemspec_method
    puts 'Removing pre version of gemspec'.color(:yellow)
    File.delete(*Dir.glob('*.gemspec'))
    puts 'Removed'.color(:green)
  end
```
If you have produced a prerelease gemspec you maybe like this method. It removes the gemspec from your sources.

```ruby
# Method for updating workspace
  def self.update_workspace_method
    puts 'Updating workspace'.color(:yellow)
    system('git add Manifest.txt Gemfile Gemfile.lock')
    system('git commit -m "Updated workspace"')
    system('git push')
    puts 'Updated workspace'.color(:green)
  end
```
In my case i have sometimes trouble with rake release, because it tells me about not registered but updated files.
The whole workspace will be committed with the comment "Updated workspace" and will be pushed to the actual branch.

```ruby
  # Method for updating .index
  def self.update_index_method
    puts 'Updating .index. Have you changed your VERSION file?'.color(:yellow)
    system('index --using VERSION Index.yml')
    system('git add .index')
    puts '.index updated'.color(:green)
  end
```
If you use Indexer from Rubyworks (<a href="https://github.com/rubyworks/indexer">https://github.com/rubyworks/indexer</a> ) this method updates the ".index". Please
keep in mind, that you have to update the VERSION file manually. Actual i haven't any idea, how to do this
automatically. If you find a solution you're welcome to send a pull request via GitHub.

``` ruby
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
```
This method adds the Manifest, Gemfile, Rakefile, History, README, bin/*, data/*, etc/*, lib/*, and test/* to git and commits them.

``` ruby
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
```
This method copies the most changed projectfiles to ../your-project-github.
That means if you have a hoe-manns repository it copies the content to hoe-manns-github. So you haven't to go to the mirror repo manually.

```ruby
# Method for copying the manuals to a target directory
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
If you have installed this Gem with "rake setup" after "gem install hoe-manns" a config file is placed in your ~/.hoe-manns/hoe-manns.cfg. There you have to replace the docdir "~/RubyMine/saigkill.github.io/docs" with your target directory. The method gets the name of the present project by asking README.{.txt, .rdoc, .md}. The name will be used as name of your target folder in your docdir.
In the case of my hoe-manns it will be copied to docdir/hoemanns. You see any other chars than alpha or numeric will be ignored.

```ruby
# Method for cleanup the pkg
  def self.clean_pkg_method
    puts 'Cleaning pkg'.color(:yellow)
    FileUtils.rm_rf('pkg') if Dir.exist?('pkg')
    puts 'Cleanup succeed'.color(:green)
  end
```
Sometimes it can be useful to remove the pkg directory from your source. So just launch this method to do this.

``` ruby
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
```
This Rake task provides 3 new Rake commands: bundle_audit:update, bundle_audit:run, and bundle_audit:check. A bundle_audit:run does bundle_audit:update and bundle_update:check. So you need in most cases just that one command.

``` ruby
def self.copy_wiki_method
    puts 'Copying wiki content to docs'.colour(:yellow)
    project = Hoe::Manns.get_projectname
    dest = "#{Dir.home}/RubymineProjects/#{project}"
    wikipath = "#{Dir.home}/RubymineProjects/#{project}.wiki"
    FileUtils.mkdir_p "#{dest}/doc", verbose: true if File.exist?('docs') == false
    files = Dir.glob("#{wikipath}/*.md")
    FileUtils.cp files, "#{dest}/docs", verbose: true
    FileUtils.mv "#{dest}/docs/home.md", "#{dest}/docs/index.md", verbose: true
    puts 'Copied wiki content'.colour(:green)
  end
```
GitLab provides for projects wiki a own git repository, which has the projectname extended with ".wiki". So this method copies the docs from projects wiki repo to the project repo and can be shipped.


```ruby
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
```
This method changes into the directory $projektname-maindir/recipes/$projektname. There it expects a "recipe.rb" file which looks like:

``` ruby
# Recipe class
class HoeMannsRubyGem < FPM::Cookery::RubyGemRecipe
  name 'hoe-manns'
  version '1.1.0'
  maintainer 'Sascha Manns <samannsml@directbox.com>'
end
```
You have to set the version manually for each build. Sure: you can run that command just after you official released your gem. :-) 



## The Rake tasks

In most cases you don't run the method directly, but use a Rake Task.

All Rake tasks in hoe-manns having a common structure:

```ruby
desc 'Update Gemfile.lock'
task :update_gemfile_lock do
    Hoe::Manns.update_gemfile_lock_method
end
```
You see, it just runs the method. A task ":update_gemfile_lock" runs a "update_gemfile_lock_method".

hoe-manns ships two Rake tasks without any methods. These tasks are used to run a bunch of other tasks in a special order.

```ruby
desc 'Run all tasks before rake release'
task :run_before_release => %w(git:manifest bundler:gemfile update_gemfile_lock update_index remove_pre_gemspec
update_workspace) do
    puts 'Ready to run rake release VERSION=x.y.z'.color(:green)
end
```
This rake task runs some rake tasks in that order: git:manifest, bundler:gemfile, update_gemfile_lock, update_index, remove_pre_gemspec and update_workspace.

```ruby
desc 'Run all tasks after rake release'
task :run_after_release => %w(send_email version:bump) do
    puts 'Release finished'.color (:green)
end
```
This task runs: send_email and version:bump. That can be useful to automate things after the release.



