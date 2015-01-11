
# configures and runs Mailman
module Mail2FrontMatter
  require 'mailman'

  class Watcher

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
          logger.info('parsing message...')
          metadata, body = Mail2FrontMatter::Parser.new(message)

          logger.info('processing body and attachments...')
          metadata, body = Mail2FrontMatter::PreProcessors.run(metadata, body)

          logger.info('saving processed post...')
          Mail2FrontMatter::Writer.write(metadata, body)
        end
      end
    end

  end
end
