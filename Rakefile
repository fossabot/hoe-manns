# -*- ruby -*-
# Copyright (C) 2013-2018 Sascha Manns <Sascha.Manns@mailbox.org>
# Release:
# Pre-release:
#* update docs
#* Update copyright years if needed, in the following paths:
#  + lib/*
#* Check version in lib/hoe-manns.rb
#* Update History.rdoc & NEWS
#* git:manifest
#* bundler:gemfile
#* bundler:gemfile_lock
#* bundle_audit:run
#* git -a -m "Anything"
#* git tag x.x.x

# Release:
#* Create Release in Github
#* rake release
#* send_email
#* clean_pkg

# Post-release:
#* Bump version
#* Add new Milestone on Github

# Dependencies
require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
Hoe.plugin :rdoc
Hoe.plugin :rubygems
Hoe.plugin :version


###########################################DEVELOPING ZONE##############################################################
# rubocop:disable Metrics/LineLength
Hoe.spec 'hoe-manns' do
  developer('Sascha Manns', 'Sascha.Manns@mailbox.org')
  license 'GPL-3.0' # this should match the license in the README
  require_ruby_version '>= 2.2.0'

  dependency 'rainbow', '~> 3.0'
  dependency 'bundler-audit', '~> 0.6'

  extra_dev_deps << ['hoe-bundler', '~> 1.3']
  extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  extra_dev_deps << ['hoe-version', '~> 1.2']
  extra_dev_deps << ['rdoc', '~> 5.1']
  extra_dev_deps << ['rspec', '~> 3.7']

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc'].to_a
  self.post_install_message = 'Please file bugreports on: https://github.com/saigkill/hoe-manns/issues'
end

##################################################SETUP ZONE############################################################



# vim: syntax=ruby

