
M2FM_GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$: << File.join(M2FM_GEM_PATH, 'fixtures')

require 'yaml'
require File.join(M2FM_GEM_PATH, 'lib', 'mail2frontmatter')
