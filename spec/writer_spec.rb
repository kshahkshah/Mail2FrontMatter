require 'spec_helper'

describe Mail2FrontMatter::Writer, "writing" do

  let(:config) { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.simple.yml') }
  let(:message_one) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'attachments.eml'))) }
  let(:blog_post) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'blog-post.yml'))) }

  it "should write a parse and processed email" do
    Mail2FrontMatter.set_config(config) do |config|
      config[:data_directory]  = File.join(M2FM_GEM_PATH, 'spec', 'installation', 'data')
      config[:media_directory] = File.join(M2FM_GEM_PATH, 'spec', 'installation', 'media')
    end

    parser = Mail2FrontMatter::Parser.new(message_one)
    metadata, body = Mail2FrontMatter::PreProcessor.process(parser.metadata, parser.body)

    Mail2FrontMatter::Writer.write(metadata, body)

    expect(File.exist?(File.join(Mail2FrontMatter.config[:data_directory], '2009-11-25-295-abandoned-elevator-shaft.html.erb'))).to be(true)
    expect(File.exist?(File.join(Mail2FrontMatter.config[:media_directory], 'images', 'IMG_0141.JPG'))).to be(true)
  end

end