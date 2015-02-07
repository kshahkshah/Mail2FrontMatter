
M2FM_GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH << File.join(M2FM_GEM_PATH, 'fixtures')

require 'yaml'
require 'fileutils'
require File.join(M2FM_GEM_PATH, 'lib', 'mail2frontmatter')

module RSpec
  # remove any data hanging around from spec runs...
  def self.clean_testbed
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'remote', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media', '*')])
    FileUtils.rm_rf(Dir[File.join(M2FM_GEM_PATH, 'spec', 'installation', '.git')])
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    RSpec.clean_testbed

    # setup a repo in spec/installation
    repo = Rugged::Repository.init_at(File.join(M2FM_GEM_PATH, 'spec', 'installation', '.git'))

    # setup another repo in spec/remote
    Rugged::Repository.init_at(File.join(M2FM_GEM_PATH, 'spec', 'remote'), :bare)

    # add the second repo as the origin of the first
    repo.remotes.create('origin', File.join(M2FM_GEM_PATH, 'spec', 'remote'))

    index = repo.index

    # stage the blank folders
    index.add(path: 'data/.gitkeep',
              oid: (Rugged::Blob.from_workdir repo, 'data/.gitkeep'),
              mode: 0100644)

    index.add(path: 'media/.gitkeep',
              oid: (Rugged::Blob.from_workdir repo, 'media/.gitkeep'),
              mode: 0100644)

    # commit them
    tree = index.write_tree(repo)
    index.write

    author = {
      email: 'sender@example.com',
      name:  'The Sender',
      time:  Time.now
    }

    Rugged::Commit.create(repo, author:     author,
                                committer:  author,
                                message:    'checking in data/media empties',
                                parents:    [],
                                tree:       tree,
                                update_ref: 'HEAD')

    # push
    repo.push 'origin', ['refs/heads/master']
  end

  config.after(:suite) do
    RSpec.clean_testbed
  end
end
