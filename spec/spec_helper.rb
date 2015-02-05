
M2FM_GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$: << File.join(M2FM_GEM_PATH, 'fixtures')

require 'yaml'
require 'fileutils'
require File.join(M2FM_GEM_PATH, 'lib', 'mail2frontmatter')

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media', '*')])
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media', '*')])
  end
end