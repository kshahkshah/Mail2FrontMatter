
# Breaks down email
module Mail2FrontMatter
  class Parser
    require 'nokogiri'
    require 'fileutils'

    attr_accessor :message, :metadata, :body

    ALLOWED_TYPES = {
      "audio" => "audio",
      "video" => "videos", 
      "image" => "images"
    }

    def initialize(message)
      @message = message
      raw_parsed_html = Nokogiri::HTML.parse(@message.html_part.body.raw_source.strip)
      parsed_html = raw_parsed_html.at("body")

      # remove extraneous nesting
      while(parsed_html.children.count == 1 && parsed_html.children.first.name == "div") do
        parsed_html = parsed_html.children.first
      end

      attachments = {}

      @message.attachments.each do |attachment|
        if Parser::ALLOWED_TYPES.keys.include?(attachment.main_type)

          # save attachments
          media_directory = File.join(Dir.pwd, 'source', Parser::ALLOWED_TYPES[attachment.main_type])
          FileUtils.mkdir_p(media_directory)

          filepath = File.join(media_directory, attachment.filename) 

          # save attachment
          File.open(filepath, "w+b", 0644) {|f| f.write attachment.body.decoded}

          # retain metadata
          attachments[attachment.cid] = {
            maintype: attachment.main_type,
            mimetype: attachment.mime_type,
            filename: attachment.filename,
            filepath: filepath
          }

        # file type not allowed
        else
          # remove cooresponding node from html
          parsed_html.xpath("//*[@src='cid:#{attachment.content_id}']").remove

        end
      end

      return {
        from:        message[:to].value,
        to:          message[:from].value,
        received:    message.date,
        title:       message.subject,
        attachments: attachments
      }, parsed_html

    end
  end
end
