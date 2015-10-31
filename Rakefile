# -*- ruby -*-
# Release:
# * update *.wiki markdown documentation for GitLab
# * enable :git
# * rake run_before_release
# * disable :git
# * Checkin
# * rake release
# * rake run_after_release

require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
# Hoe.plugin :deveiate
Hoe.plugin :doofus
Hoe.plugin :email
Hoe.plugin :gemspec
# Hoe.plugin :gem_prelude_sucks
#Hoe.plugins.delete :git
Hoe.plugin :git
Hoe.plugin :history
Hoe.plugin :highline
#Hoe.plugin :inline
Hoe.plugin :manns
# Hoe.plugin :mercurial
# Hoe.plugin :perforce
Hoe.plugin :packaging
# Hoe.plugin :racc
# Hoe.plugin :rcov
Hoe.plugin :reek
Hoe.plugin :rdoc
Hoe.plugin :rubocop
Hoe.plugin :rubygems
# Hoe.plugin :seattlerb
Hoe.plugin :travis
Hoe.plugin :version
Hoe.plugin :website
Hoe.plugin :yard

###########################################DEVELOPING ZONE##############################################################
# rubocop:disable Metrics/LineLength
Hoe.spec 'hoe-manns' do
  developer('Sascha Manns', 'samannsml@directbox.com')
  license 'MIT' # this should match the license in the README
  require_ruby_version '>= 2.2.0'

  email_to << 'ruby-talk@ruby-lang.org'
  #email_to << 'Sascha.Manns@directbox.com'

  dependency 'parseconfig', '~> 1.0'
  dependency 'rainbow', '~> 2.0'
  dependency 'indexer', '~> 0.3'
  dependency 'bundler-audit', '~> 0.4.0'
  dependency 'pandoc-ruby', '~> 1.0.0'

  extra_dev_deps << ['coveralls', '~> 0.8.3']
  extra_dev_deps << ['digest', '~> 0.0.1']
  extra_dev_deps << ['gem-release', '~> 0.7']
  extra_dev_deps << ['hoe-bundler', '~> 1.2']
  extra_dev_deps << ['hoe-doofus', '~> 1.0']
  extra_dev_deps << ['hoe-gemspec', '~> 1.0']
  extra_dev_deps << ['hoe-git', '~> 1.6']
  extra_dev_deps << ['hoe-highline', '~> 0.2']
  extra_dev_deps << ['hoe-manns', '~> 1.4.3']
  extra_dev_deps << ['hoe-packaging', '~> 1.1']
  extra_dev_deps << ['hoe-reek', '~> 1.0']
  extra_dev_deps << ['hoe-rubocop', '~> 0.1']
  extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  extra_dev_deps << ['hoe-travis', '~> 1.2']
  extra_dev_deps << ['hoe-version', '~> 1.2']
  extra_dev_deps << ['hoe-yard', '~> 0.1']
  extra_dev_deps << ['minitest', '~> 5.8']
  extra_dev_deps << ['rake', '~> 10.0']
  extra_dev_deps << ['reek', '~> 3.3']
  extra_dev_deps << ['rspec', '~> 3.3']
  extra_dev_deps << ['rubocop', '~> 0.34']
  extra_dev_deps << ['simplecov', '~> 0.10']
  extra_dev_deps << ['ZenTest', '~> 4.11']

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc'].to_a
  self.post_install_message = '*** Edit your .hoerc: http://bit.ly/1L9hBwN *** Please file bugreports and feature requests on: https://gitlab.com/saigkill/hoe-manns/issues'
end

##################################################SETUP ZONE############################################################



# vim: syntax=ruby
