# -*- ruby -*-
# Release:
# * bump version
# * do stuff
# * update documentation
# * enable :git
# * rake run_before_release
# * disable :git
# * Checkin
# * rake release
# * rake run_after_release

require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
Hoe.plugin :email
#Hoe.plugin :git
Hoe.plugin :manns
Hoe.plugin :rdoc
Hoe.plugin :rubocop
Hoe.plugin :rubygems
Hoe.plugin :version

###########################################DEVELOPING ZONE##############################################################
# rubocop:disable Metrics/LineLength
Hoe.spec 'hoe-manns' do
  developer('Sascha Manns', 'samannsml@directbox.com')
  license 'MIT' # this should match the license in the README
  require_ruby_version '>= 2.2.0'

  email_to << 'ruby-talk@ruby-lang.org'
  #email_to << 'Sascha.Manns@directbox.com'

  dependency 'parseconfig', '~> 1.0'
  dependency 'rainbow', '~> 2.1'
  dependency 'bundler-audit', '~> 0.4'

  extra_dev_deps << ['coveralls', '~> 0.8']
  extra_dev_deps << ['hoe-bundler', '~> 1.3']
  extra_dev_deps << ['hoe-git', '~> 1.6']
  extra_dev_deps << ['hoe-manns', '~> 1.6']
  extra_dev_deps << ['hoe-rubocop', '~> 1.0']
  extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  extra_dev_deps << ['hoe-seattlerb', '~> 1.3']
  extra_dev_deps << ['hoe-version', '~> 1.2']
  extra_dev_deps << ['rake', '~> 11.2']
  extra_dev_deps << ['rspec', '~> 3.5']
  extra_dev_deps << ['simplecov', '~> 0.12']

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc'].to_a
  self.post_install_message = '*** Edit your .hoerc: https://saigkill.github.io/docs/hoe-manns/en-US/html/index.html *** Please file bugreports and feature requests on: https://saigkill.myjetbrains.com/youtrack/issues'
end

##################################################SETUP ZONE############################################################



# vim: syntax=ruby

