require 'spec_helper'
require 'byebug'

describe Mail2FrontMatter::Parser, "parsing" do

  let(:message_one) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'attachments.eml'))) }

  it "should parse HTML email" do
    expect {
      Mail2FrontMatter::Parser.new(message_one)
    }.to_not raise_error
  end

  it "should return an html body as a string" do
    Mail2FrontMatter::Parser.new(message_one).body.should match(/Charlie<br>/)
  end

  it "should save attachments to disk" do
    attachment_path = Mail2FrontMatter::Parser.new(message_one).metadata[:attachments].first[1][:filepath]
    File.exist?(attachment_path).should eq(true)
  end

end