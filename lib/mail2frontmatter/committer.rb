
# Commits Changes to git
# 
module Mail2FrontMatter
  class Committer

    begin
      require 'rugged'
      @@available = true

    rescue LoadError
      @@available = false
    end

    def self.available?
      @@available
    end

    def self.commit(metadata, body)
      repo = Rugged::Repository.new(Mail2FrontMatter.config[:git][:path])
      index = repo.index

      # stage frontmatter/erb
      relative_path = metadata[:filepath].gsub(Mail2FrontMatter.config[:git][:path]+'/', '')

      index.add({
        path: relative_path, 
        oid: (Rugged::Blob.from_workdir repo, relative_path),
        mode: 0100644
      })

      # stage attachments
      metadata[:attachments].each_pair do |k,filemeta|
        relative_path = filemeta[:filepath].gsub(Mail2FrontMatter.config[:git][:path]+'/', '')

        index.add({
          path: relative_path,
          oid: (Rugged::Blob.from_workdir repo, relative_path),
          mode: 0100644
        })
      end

      # commit
      tree = index.write_tree(repo)
      index.write

      author = { 
        email: Mail2FrontMatter.config[:git][:email] || metadata[:from].match(/\<(.*)\>/)[1],
        name:  Mail2FrontMatter.config[:git][:name]  || metadata[:from].match(/(.*) \<.*\>/)[1], 
        time:  Time.now 
      }

      commit = Rugged::Commit.create(repo, {
        author:     author,
        committer:  author,
        message:    "post via email, #{metadata[:subject]}",
        parents:    [repo.head.target],
        tree:       tree,
        update_ref: 'HEAD'
      })

      # push
      repo.push 'origin', ['refs/heads/master']

      # return sha
      repo.references["refs/heads/master"].target_id
    end

  end
end
