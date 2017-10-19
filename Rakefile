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
Hoe.plugin :doofus
Hoe.plugin :git
Hoe.plugin :manns
Hoe.plugin :rdoc
Hoe.plugin :reek
Hoe.plugin :rubocop
Hoe.plugin :rubygems
Hoe.plugin :travis
Hoe.plugin :version


###########################################DEVELOPING ZONE##############################################################
# rubocop:disable Metrics/LineLength
Hoe.spec 'hoe-manns' do
  developer('Sascha Manns', 'Sascha.Manns@mailbox.org')
  license 'GPL-3' # this should match the license in the README
  require_ruby_version '>= 2.2.0'

  dependency 'rainbow', '~> 2.2'
  dependency 'bundler-audit', '~> 0.6'

  extra_dev_deps << ['coveralls', '~> 0.8']
  extra_dev_deps << ['hoe-bundler', '~> 1.3']
  extra_dev_deps << ['hoe-doofus', '~> 1.0']
  extra_dev_deps << ['hoe-git', '~> 1.6']
  extra_dev_deps << ['hoe-manns', '~> 1.6']
  extra_dev_deps << ['hoe-reek', '~> 1.1']
  extra_dev_deps << ['hoe-rubocop', '~> 1.0']
  extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  extra_dev_deps << ['hoe-travis', '~> 1.3']
  extra_dev_deps << ['hoe-version', '~> 1.2']
  extra_dev_deps << ['rake', '~> 12.1']
  extra_dev_deps << ['rdoc', '~> 5.1']
  extra_dev_deps << ['rubocop', '~> 0.50']
  extra_dev_deps << ['rspec', '~> 3.7']

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc'].to_a
  self.post_install_message = 'Please file bugreports on: https://bugs.launchpad.net/hoe-manns'
end

##################################################SETUP ZONE############################################################



# vim: syntax=ruby

