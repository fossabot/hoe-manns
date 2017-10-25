require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'lib/hoe/manns')
require File.join(File.dirname(__FILE__), '..', 'lib/hoe/manns-methods')
require File.join(File.dirname(__FILE__), '..', 'spec/spec_helper')
require 'fileutils'

# TODO: Try to split this block into smaller once
# rubocop:disable Metrics/BlockLength
describe 'Hoe::Manns' do
  describe 'bundle_install' do
    it 'installs a bundle' do
      success = Hoe::MannsMethods.bundle_install
      expect(success)
    end
  end

  describe 'update_gemfile_lock_method' do
    it 'creates a new Gemfile.lock' do
      FileUtils.rm(File.join(File.dirname(__FILE__), '..', 'Gemfile.lock'))
      Hoe::MannsMethods.update_gemfile_lock_method
      avail = File.exist?(File.join(File.dirname(__FILE__), '..',
                                    'Gemfile.lock'))
      expect(avail)
    end
  end

  describe 'remove_pre_gemspec' do
    it 'removes the old gemspec' do
      FileUtils.touch('hoe-manns.gemspec')
      Hoe::MannsMethods.remove_pre_gemspec_method
      gemspec = Dir.glob('*.gemspec').empty?
      expect(gemspec)
    end
  end

  describe 'clean_pkg' do
    it 'cleans the pkg' do
      Hoe::MannsMethods.clean_pkg_method
    end
  end
end
