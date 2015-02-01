
# configures and kicks off Mailman
module Mail2FrontMatter
  require 'mailman'

  class Watcher

    def self.run
      mail_protocol = Mail2FrontMatter.config[:protocol] || :imap
      poll_interval = Mail2FrontMatter.config[:interval] || 60

      @receiver = Mail2FrontMatter.config[:receiver]
      @senders  = Mail2FrontMatter.config[:senders]

      Mailman.config.poll_interval = poll_interval
      Mailman.config.ignore_stdin = true

      Mailman.config.send("#{mail_protocol}=", Mail2FrontMatter.config[:mailman])
      Mailman.config.logger = Mail2FrontMatter.logger

      Mailman::Application.run do
        from(@senders).to(@receiver) do
          logger = Mailman.config.logger

          logger.info('parsing message...')
          parser = Mail2FrontMatter::Parser.new(message)

          logger.info('processing body and attachments...')
          metadata, body = Mail2FrontMatter::PreProcessor.process(parser.metadata, parser.body)

          logger.info('saving processed post...')
          Mail2FrontMatter::Writer.write(metadata, body)
        end
      end
    end

  end
end
