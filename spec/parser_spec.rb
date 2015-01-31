require 'spec_helper'

describe Mail2FrontMatter::Parser, "parsing" do

  let(:message_one) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'attachments.eml'))) }

  it "should parse HTML email" do
    expect {
      Mail2FrontMatter::Parser.new(message_one)
    }.to_not raise_error
  end

  it "should return an html body as a string" do
    body = Mail2FrontMatter::Parser.new(message_one).body
    expect(body).to match(/Charlie<br>/)
  end

  it "should return have an email metadata hash with a from key" do
    from = Mail2FrontMatter::Parser.new(message_one).metadata[:from]
    expect(from).to eq("Kunal Shah <kunalashokshah@gmail.com>")
  end

  it "should return have an email metadata hash with a to key" do
    to = Mail2FrontMatter::Parser.new(message_one).metadata[:to]
    expect(to).to eq("stream@kunalashah.com")
  end

  it "should return have an email metadata hash with a received key" do
    received = Mail2FrontMatter::Parser.new(message_one).metadata[:received]
    expect(received.class).to eq(DateTime)
  end

  it "should return have an email metadata hash with a subject key" do
    subject = Mail2FrontMatter::Parser.new(message_one).metadata[:subject]
    expect(subject).to eq("295 Abandoned Elevator Shaft")
  end

  it "should save attachments to disk" do
    attachment_path = Mail2FrontMatter::Parser.new(message_one).metadata[:attachments].first[1][:filepath]
    expect(File.exist?(attachment_path)).to eq(true)
  end

end