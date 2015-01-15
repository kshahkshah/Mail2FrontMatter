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

  it "should return have an email metadata hash with a from key" do
    from = Mail2FrontMatter::Parser.new(message_one).metadata[:from]
    from.should eq("Kunal Shah <kunalashokshah@gmail.com>")
  end

  it "should return have an email metadata hash with a to key" do
    to = Mail2FrontMatter::Parser.new(message_one).metadata[:to]
    to.should eq("stream@kunalashah.com")
  end

  it "should return have an email metadata hash with a received key" do
    received = Mail2FrontMatter::Parser.new(message_one).metadata[:received]
    received.class.should eq(DateTime)
  end

  it "should return have an email metadata hash with a subject key" do
    subject = Mail2FrontMatter::Parser.new(message_one).metadata[:subject]
    subject.should eq("295 Abandoned Elevator Shaft")
  end

  it "should save attachments to disk" do
    attachment_path = Mail2FrontMatter::Parser.new(message_one).metadata[:attachments].first[1][:filepath]
    File.exist?(attachment_path).should eq(true)
  end

end