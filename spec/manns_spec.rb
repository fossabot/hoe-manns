require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'lib/hoe/manns')
require File.join(File.dirname(__FILE__), '..', 'spec/spec_helper')
require 'fileutils'

describe 'Hoe::Manns' do
  describe 'update_gemfile_lock_method' do
    it 'creates a new Gemfile.lock' do
      FileUtils.rm(File.join(File.dirname(__FILE__), '..', 'Gemfile.lock'))
      Hoe::Manns.update_gemfile_lock_method
      avail = File.exist?(File.join(File.dirname(__FILE__), '..',
                                    'Gemfile.lock'))
      expect(avail)
    end
  end

  describe 'remove_pre_gemspec' do
    it 'removes the old gemspec' do
      FileUtils.touch('hoe-manns.gemspec')
      Hoe::Manns.remove_pre_gemspec_method
      gemspec = Dir.glob('*.gemspec').empty?
      expect(gemspec)
    end
  end

  describe 'clean_pkg' do
    it 'cleans the pkg' do
      Hoe::Manns.clean_pkg_method
    end
  end
end
