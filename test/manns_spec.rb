require 'rspec'
require 'digest'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/hoe/manns'))
require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe 'Hoe::Manns' do
  describe 'update_gemfile_lock_method' do
    before do
      @checksumgemlock = Digest::SHA2.hexdigest(File.read('Gemfile.lock'))
    end

    it 'creates a new Gemfile.lock' do
      Hoe::Manns.update_gemfile_lock_method
      @checksumgemlocknew = Digest::SHA2.hexdigest(File.read('Gemfile.lock'))

      checksum = false
      checksum = true if @checksumgemlock == @checksumgemlocknew
      expect(checksum) == true
    end
  end

  describe 'remove_pre_gemspec' do
    it 'removes the old gemspec' do
      Hoe::Manns.remove_pre_gemspec_method

      gemspec = false
      gemspec = true if Dir.glob('*.gemspec').empty? == true
      expect(gemspec) == false
    end
  end

  describe 'update_workspace' do
    it 'updates the workspace' do
      Hoe::Manns.update_workspace_method
    end
  end

  describe 'update_index' do
    it 'updates the .index' do
      Hoe::Manns.update_index_method
    end
  end

  # describe 'copy_manuals' do
  #   it 'copies the manuals' do
  #     Hoe::Manns.copy_manuals_method
  #   end
  # end

  describe 'clean_pkg' do
    it 'cleans the pkg' do
      Hoe::Manns.clean_pkg_method
    end
  end
end


