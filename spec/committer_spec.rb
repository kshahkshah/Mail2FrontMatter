require 'spec_helper'
require 'byebug'

describe Mail2FrontMatter::Committer, "committing" do
  require 'rugged'

  let(:config) { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.simple.yml') }
  let(:message_one) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'attachments.eml'))) }
  let(:blog_post) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'blog-post.yml'))) }

  it "should commit new posts" do
    Mail2FrontMatter.set_config(config) do |config|
      config[:data_directory]  = File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data')
      config[:media_directory] = File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media')
      config[:git] = { path: File.join(M2FM_GEM_PATH, 'spec', 'installation') }
    end

    repo = Rugged::Repository.new(Mail2FrontMatter.config[:git][:path])
    opening_sha = repo.references["refs/heads/master"].target_id

    parser = Mail2FrontMatter::Parser.new(message_one)
    Mail2FrontMatter::Writer.write(parser.metadata, parser.body)
    Mail2FrontMatter::Committer.commit(parser.metadata, parser.body)

    closing_sha = repo.references["refs/heads/master"].target_id

    expect(opening_sha == closing_sha).to be(false)
  end
end