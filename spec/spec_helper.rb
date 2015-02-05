
M2FM_GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$: << File.join(M2FM_GEM_PATH, 'fixtures')

require 'yaml'
require 'fileutils'
require File.join(M2FM_GEM_PATH, 'lib', 'mail2frontmatter')

RSpec.configure do |config|
  config.before(:suite) do
    repo = Rugged::Repository.init_at(File.join(M2FM_GEM_PATH, 'spec', 'installation', '.git'))
    index = repo.index

    index.add({
      path: 'data/.gitkeep', 
      oid: (Rugged::Blob.from_workdir repo, 'data/.gitkeep'),
      mode: 0100644
    })

    index.add({
      path: 'media/.gitkeep', 
      oid: (Rugged::Blob.from_workdir repo, 'media/.gitkeep'),
      mode: 0100644
    })

    # commit
    tree = index.write_tree(repo)
    index.write

    author = { 
      email: 'sender@example.com',
      name:  'The Sender',
      time:  Time.now 
    }

    commit = Rugged::Commit.create(repo, {
      author:     author,
      committer:  author,
      message:    "checking in data/media empties",
      parents:    [],
      tree:       tree,
      update_ref: 'HEAD'
    })

    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media', '*')])
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', '.git')])
  end
end