require "mail2frontmatter/version"
require 'yaml'

module Mail2FrontMatter
  # Your code goes here...

  # Mailman wrapper
  class Watcher
    require 'mailman'

    attr_accessor :logger

    def initialize(config = nil, &block)
      # load config from file
      if config.is_a?(String)
        config = YAML.load_file(config).deep_symbolize_keys!

      # load config from file at default data/mail2frontmatter.yml relative from run directory
      elsif config.is_a?(NilClass)

        default_config = File.join(Dir.pwd, 'data', 'mail2frontmatter.yml')

        if File.exist?(default_config)
          config = YAML.load_file(default_config).deep_symbolize_keys!
        else
          raise LoadError, 'no configuration given or found at ./data/mail2frontmatter.yml'
        end

      elsif !config.is_a?(Hash)
        raise ArgumentError, 'not a valid configuration type'
      end

      yield(config) if block_given?

      mail_protocol = config.delete(:protocol) || :imap
      poll_interval = config.delete(:interval) || 60

      @receiver = config.delete(:receiver)
      @senders  = config.delete(:senders)
      @logger   = Logger.new(config.delete(:log_file))

      Mailman.config.poll_interval = poll_interval
      Mailman.config.ignore_stdin = true

      Mailman.config.send("#{mail_protocol}=", config[:mailman])
      Mailman.config.logger = @logger
    end

    def run
      Mailman::Application.run do
        from(@senders).to(@receiver) do
          parser = Mail2FrontMatter::Parser.new(message)
          writer = Mail2FrontMatter::Writer.new({ 
            metadata: parser.metadata, 
            content:  parser.body
          })
          writer.write
        end
      end
    end
  end

  class Processor
  end

  # Breaks down email
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

      @body = parsed_html.inner_html

      @metadata = {
        from:        message[:to].value,
        to:          message[:from].value,
        received:    message.date,
        title:       message.subject,
        attachments: attachments
      }

    end
  end

  # Saves to filesystem (future: db option)
  class Writer
    require 'yaml'
    require 'active_support/inflector'

    attr_accessor :location, :data

    def initialize(attrs)
      # this is NOT suppose to be here, this is supposed to be configurable
      # but I haven't made a global config object yet
      data_directory = File.join(Dir.pwd, 'source', 'blog')
      filename = [attrs[:metadata][:received].strftime("%Y-%m-%d"), '-', attrs[:metadata][:title].parameterize, '.html.erb'].join

      @location = File.join(data_directory, filename)
      @data     = attrs[:metadata].to_yaml + "---\n" + attrs[:content]
    end

    def write
      File.write(@location, @data)
    end

  end
end
